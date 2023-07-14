import 'CoreLibs/object'
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

class('Food').extends()

function Food:init(row)
  Food.super.init(self)

  self.x = 405
  self.row = row
  self.isConsumed = false
end

function Food:move(isConsuming)
  local oldX = self.x
  self.x -= 3

  if oldX > 53 and self.x <= 53 then
    self.isConsumed = isConsuming
  end
end

function Food:isDead()
  if self.isConsumed then
    return self.x <= 29
  else
    return self.x <= 53
  end
end

function Food:draw()
  gfx.fillCircleAtPoint(self.x, 29 + (self.row - 1) * 60, 5)
end
