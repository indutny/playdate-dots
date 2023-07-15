import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/timer'
import 'CoreLibs/easing'

local FOOD_RADIUS <const> = 5
local START_OFFSET <const> = 375

local gfx <const> = playdate.graphics

class('Food').extends()

function Food:init(bucket, speed)
  Food.super.init(self)

  self.bucket = bucket
  self.speed = speed
  self.isConsumed = nil

  self.moveTimer = playdate.timer.new(
    (START_OFFSET - self.bucket.getX()) / speed * 1000,
    START_OFFSET - self.bucket:getX(),
    0,
    playdate.easingFunctions.linear)
end

function Food:remove()
  self.moveTimer:remove()
end

function Food:isDead()
  local x = self.moveTimer.value
  if self.isConsumed then
    return x <= 0
  else
    return x <= self.bucket:getOpening()
  end
end

function Food:update()
  local x = self.moveTimer.value
  local bucketOpening = self.bucket:getOpening()

  if self.isConsumed == nil and x <= bucketOpening then
    self.isConsumed = self.bucket:isOpen()
  end
end

function Food:getX()
  return self.moveTimer.value + self.bucket:getX()
end

function Food:getY()
  return self.bucket:getY()
end

function Food:draw()
  local offset = self.moveTimer.value

  if self:isDead() then
    return
  end

  local bucketOpening = self.bucket:getOpening()
  local radius = FOOD_RADIUS
  if offset <= bucketOpening then
    radius = offset / bucketOpening * (FOOD_RADIUS - 2) + 2
  end
  gfx.fillCircleAtPoint(self:getX(), self:getY(), radius)
end
