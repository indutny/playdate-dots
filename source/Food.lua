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
  self.x -= 1

  if self.x == 53 then
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
  -- TODO(indutny): RowObject
  gfx.fillCircleAtPoint(self.x, 29 + (self.row - 1) * 60, 5)
end
