import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/timer'
import 'CoreLibs/easing'

local FOOD_RADIUS <const> = 5

local gfx <const> = playdate.graphics

class('Food').extends()

function Food:init(bucket, speed)
  Food.super.init(self)

  self.bucket = bucket
  self.speed = speed
  self.isConsumed = nil

  local screenWidth = playdate.display.getWidth()

  self.initialOffset = screenWidth - self.bucket:getX()

  self.moveTimer = playdate.timer.new(
    self.initialOffset / speed * 1000,
    0,
    1,
    playdate.easingFunctions.linear)
end

function Food:remove()
  self.moveTimer:remove()
end

function Food:isDead()
  local offset = self:getOffset()
  if self.isConsumed then
    return offset <= 0
  else
    return offset <= self.bucket:getOpening()
  end
end

function Food:update()
  local offset = self:getOffset()
  local bucketOpening = self.bucket:getOpening()

  if self.isConsumed == nil and offset <= bucketOpening then
    self.isConsumed = self.bucket:isOpen()
  end
end

function Food:getOffset()
  return (1 - self.moveTimer.value) * self.initialOffset
end

function Food:getX()
  return self.bucket:getX() + self:getOffset()
end

function Food:getY()
  return self.bucket:getY()
end

function Food:draw()
  local offset = self:getOffset()

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
