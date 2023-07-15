import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'CoreLibs/ui'

import 'scenes/Scene'
import 'scenes/Menu'
import 'scenes/GameOver'

import 'objects/Bucket'
import 'objects/Food'

local MAX_LIFE <const> = 5
local FOOD_DISTANCE <const> = 85
local FOOD_SPEED <const> = 45

local gfx <const> = playdate.graphics

local heartImage = gfx.image.new('images/heart')
local hitSamples = {
  playdate.sound.sampleplayer.new('sounds/hit-1.wav'),
  playdate.sound.sampleplayer.new('sounds/hit-2.wav'),
  playdate.sound.sampleplayer.new('sounds/hit-3.wav'),
  playdate.sound.sampleplayer.new('sounds/hit-4.wav'),
}
local missSample = playdate.sound.sampleplayer.new('sounds/miss.wav')
local upSample = playdate.sound.sampleplayer.new('sounds/up.wav')
local loseSample = playdate.sound.sampleplayer.new('sounds/lose.wav')

class('Game').extends(Scene)

function Game:init()
  Game.super.init(self)

  self.buckets = {Bucket(2, 0, hitSamples[1]), Bucket(3, 180, hitSamples[2])}
  self.foodList = {}
  self.score = 0
  self.life = MAX_LIFE

  self.speedMultiplier = 1
  self.lastFoodRow = 1

  self:addFood()
end

function Game:remove()
  for _, bucket in ipairs(self.buckets) do
    if bucket ~= nil then
      bucket:remove()
    end
  end
  for _, food in ipairs(self.foodList) do
    food:remove()
  end
end

function Game:addFood()
  -- Always select a row different from the last one
  self.lastFoodRow = (self.lastFoodRow + math.random(1, #self.buckets - 1) - 1) % #self.buckets + 1
  local row = self.lastFoodRow
  local bucket = self.buckets[row]
  local food = Food(bucket, self:getFoodSpeed())
  table.insert(self.foodList, food)

  -- Add more food
  playdate.timer.new(FOOD_DISTANCE / self:getFoodSpeed() * 1000, function()
    self:addFood()
  end)
end

function Game:getFoodSpeed()
  return self.speedMultiplier * FOOD_SPEED
end

function Game:bumpFoodSpeed()
  -- Do not bump speed initially
  if #self.buckets < 3 then
    return
  end

  -- Bump faster at first, then slower
  if self.speedMultiplier < 1.5 then
    self.speedMultiplier += 1 / 32
  elseif self.speedMultiplier < 2 then
    self.speedMultiplier += 1 / 64
  else
    self.speedMultiplier += 1 / 128
  end
end

function Game:emptyBucket(row)
  local bucket = self.buckets[row]

  -- Always select an angle different from the previous one
  local delta = math.random(0, 1)
  bucket:emptyAndRotate(
    (delta - 0.5) * 2 * 90,
    -- Quarter of delta between food
    FOOD_DISTANCE / self:getFoodSpeed() / 4 * 1000
  )
  upSample:play()

  if self.life < MAX_LIFE then
    self.life += 1
  end
end

function Game:incScore()
  self.score += 1
  if self.score == 5 then
    self.buckets[1]:moveToRow(1 + 1 / 3)
    self.buckets[2]:moveToRow(4 - 1 / 3)
    table.insert(self.buckets, Bucket(2.5, 90, hitSamples[3]))
  elseif self.score == 30 then
    self.buckets[1]:moveToRow(1)
    self.buckets[2]:moveToRow(4)
    self.buckets[3]:moveToRow(2)
    table.insert(self.buckets, Bucket(3, 270, hitSamples[4]))
  elseif self.score == 100 then
    for _, bucket in ipairs(self.buckets) do
      bucket:setOpeningAngle(30)
    end
  end
end

function Game:update()
  local crank = playdate.getCrankPosition()

  -- Update objects

  for _, bucket in ipairs(self.buckets) do
    if bucket ~= nil then
      bucket:update(crank)
    end
  end

  for i = #self.foodList, 1, -1 do
    local food = self.foodList[i]
    local bucket = food.bucket

    food:update()

    if food:isDead() then
      if food.isConsumed then
        bucket:feed()
        if not bucket:isFull() then
          bucket.hitSample:play()
        end
        self:incScore()
        self:bumpFoodSpeed()
      else
        self.life -= 1

        if self.life <= 0 then
          loseSample:play()
          self:toGameOver()
        else
          missSample:play()
        end
      end
      food:remove()
      table.remove(self.foodList, i)
    end
  end

  for row = #self.buckets, 1, -1 do
    local bucket = self.buckets[row]
    if bucket:isFull() then
      self:emptyBucket(row)
    end
  end

  -- Draw objects

  gfx.setLineWidth(4)

  for row, bucket in ipairs(self.buckets) do
    bucket:draw(row)
  end
  for _, food in ipairs(self.foodList) do
    food:draw()
  end

  self:drawScore()
  self:drawLife()
end

function Game:drawScore()
  gfx.drawTextAligned(
    'Score: ' .. tostring(self.score),
    398,
    2,
    kTextAlignment.right)
end

function Game:drawLife()
  for i = 1, self.life do
    heartImage:draw(398 - 18 * i, 222)
  end
end

function Game:toGameOver()
  setCurrentScene(GameOver(self.score))
end

function Game:BButtonUp()
  setCurrentScene(Menu())
end
