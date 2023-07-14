import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"

import "scenes/Scene"
import "scenes/Menu"
import "scenes/GameOver"

import "objects/Bucket"
import "objects/Food"

local MAX_LIFE <const> = 5
local gfx <const> = playdate.graphics
local heartImage = gfx.image.new("images/heart")

class("Game").extends(Scene)

function Game:init()
  Game.super.init(self)

  self.buckets = {Bucket(0), Bucket(90), Bucket(180), Bucket(270)}
  self.food = {}
  self.score = 0
  self.life = MAX_LIFE

  self.foodTimer = playdate.timer.keyRepeatTimerWithDelay(1250, 1250, Game.addFood, self)
  self.foodSpeed = 2
end

function Game:remove()
  self.foodTimer:remove()
end

function Game:addFood()
  table.insert(self.food, Food(math.random(1, 4)))
end

function Game:bumpFoodSpeed()
  self.foodSpeed += 1 / 64
  if self.foodSpeed < 3 then
    self.foodTimer.delay = 1250
  elseif self.foodSpeed < 4 then
    self.foodTimer.delay = 1000
  else
    self.foodTimer.delay = 850
  end
end

function Game:update()
  local crank = playdate.getCrankPosition()

  -- Update objects

  for _, bucket in ipairs(self.buckets) do
    if bucket ~= nil then
      bucket:setAngle(crank)
    end
  end

  for i = #self.food, 1, -1 do
    local f = self.food[i]
    local b = self.buckets[f.row]

    f:setSpeed(self.foodSpeed)
    f:move(b:isOpen())

    if f:isDead() then
      if f.isConsumed then
        -- TODO(indutny): sound
        b:feed()
        self.score += 1
        self:bumpFoodSpeed()
      else
        self.life -= 1

        if self.life <= 0 then
          self:toGameOver()
        end
      end
      table.remove(self.food, i)
    end
  end

  for row = #self.buckets, 1, -1 do
    local bucket = self.buckets[row]
    if bucket:isFull() then
      -- TODO(indutny): sound and animation

      -- Make sure that new bucket is always rotated differently
      local newBucket = Bucket(
        (bucket.angleOffset + math.random(1, 3) * 90) % 360)
      newBucket:setAngle(crank)
      self.buckets[row] = newBucket
      if self.life < MAX_LIFE then
        self.life += 1
      end

      -- Remove all food on this row
      for i = #self.food, 1, -1 do
        local f = self.food[i]
        if f.row == row then
          table.remove(self.food, i)
        end
      end
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
    "*Score: " .. tostring(self.score) .. "*",
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
