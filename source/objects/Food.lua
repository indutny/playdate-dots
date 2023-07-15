import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/frameTimer'
import 'CoreLibs/easing'

local FOOD_RADIUS <const> = 5

local gfx <const> = playdate.graphics

class('Food').extends()

function Food:init(row)
  Food.super.init(self)

  self.x = 405
  self.row = row
  self.isConsumed = false
  self.speed = 1

  self.fadeOutTimer = nil
end

function Food:remove()
  if self.fadeOutTimer ~= nil then
    self.fadeOutTimer:remove()
  end
end

function Food:fadeOut()
  if self:isFadingOut() then
    return
  end

  self.fadeOutTimer = playdate.frameTimer.new(
    15,
    FOOD_RADIUS,
    0,
    playdate.easingFunctions.inOutCubic)
end

function Food:setSpeed(speed)
  self.speed = speed
end

function Food:move(isConsuming)
  local oldX = self.x
  self.x -= self.speed

  if oldX > 53 and self.x <= 53 then
    self.isConsumed = isConsuming
  end
end

function Food:isFadingOut()
  return self.fadeOutTimer ~= nil
end

function Food:isDead()
  if self.isConsumed then
    return self.x <= 29
  else
    return self.x <= 53
  end
end

function Food:draw()
  local radius = FOOD_RADIUS
  if self:isFadingOut() then
    radius = self.fadeOutTimer.value
  elseif self.x <= 53 then
    radius = math.max(0, self.x - 29) / (53 - 29) * (FOOD_RADIUS - 2) + 2
  end
  gfx.fillCircleAtPoint(self.x, 29 + (self.row - 1) * 60, radius)
end
