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
local INITIAL_FOOD_COUNTDOWN <const> = 85
local INITIAL_FOOD_SPEED <const> = 1.5

local gfx <const> = playdate.graphics

local heartImage = gfx.image.new('images/heart')
local hitSample = playdate.sound.sampleplayer.new('sounds/hit.wav')
local missSample = playdate.sound.sampleplayer.new('sounds/miss.wav')
local upSample = playdate.sound.sampleplayer.new('sounds/up.wav')
local loseSample = playdate.sound.sampleplayer.new('sounds/lose.wav')

class('Game').extends(Scene)

function Game:init()
  Game.super.init(self)

  self.buckets = {Bucket(0), Bucket(90), Bucket(180), Bucket(270)}
  self.food = {}
  self.score = 0
  self.life = MAX_LIFE
  self.foodCountdown = 0

  self.foodSpeed = INITIAL_FOOD_SPEED
  self.lastFoodRow = 1
end

function Game:remove()
  for _, bucket in ipairs(self.buckets) do
    bucket:remove()
  end
  for _, f in ipairs(self.food) do
    f:remove()
  end
end

function Game:addFood()
  -- Always select a row different from the last one
  self.lastFoodRow = (self.lastFoodRow + math.random(1, 3) - 1) % 4 + 1
  table.insert(self.food, Food(self.lastFoodRow))
end

function Game:bumpFoodSpeed()
  self.foodSpeed += 1 / 64
end

function Game:emptyBucket(row)
  local bucket = self.buckets[row]

  -- Always select an angle different from the previous one
  local delta = math.random(0, 1)
  bucket:emptyAndRotate(
    (delta - 0.5) * 2 * 90,
    -- Quarter of delta between food
    INITIAL_FOOD_COUNTDOWN / self.foodSpeed / 4
  )
  upSample:play()

  if self.life < MAX_LIFE then
    self.life += 1
  end

  -- Remove food on left side of this row
  for _, f in ipairs(self.food) do
    if f.row == row and f.x <= 200 then
      f:fadeOut()
    end
  end
end

function Game:update()
  local crank = playdate.getCrankPosition()

  self.foodCountdown -= self.foodSpeed
  if self.foodCountdown <= 0 then
    self:addFood()
    self.foodCountdown = INITIAL_FOOD_COUNTDOWN
  end

  -- Update objects

  for _, bucket in ipairs(self.buckets) do
    if bucket ~= nil then
      bucket:update(crank)
    end
  end

  for i = #self.food, 1, -1 do
    local f = self.food[i]
    local b = self.buckets[f.row]

    f:setSpeed(self.foodSpeed)
    f:move(b:isOpen())

    if f:isDead() then
      if f:isFadingOut() then
        -- Nothing, really. Just let it disappear
      elseif f.isConsumed then
        b:feed()
        if not b:isFull() then
          hitSample:play()
        end
        self.score += 1
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
      f:remove()
      table.remove(self.food, i)
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
  for _, f in ipairs(self.food) do
    f:draw()
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
