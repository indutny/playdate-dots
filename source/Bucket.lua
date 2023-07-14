import 'CoreLibs/object'
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

class('Bucket').extends()

function Bucket:init(angleOffset)
  Bucket.super.init(self)

  self.angleOffset = angleOffset
  self.angle = 0
  self.score = 0
end

function Bucket:setAngle(angle)
  self.angle = angle
end

function Bucket:isOpen()
  local rotation = (self.angle + self.angleOffset) % 360
  return 135 < rotation and rotation < 225
end

function Bucket:feed()
  if not self:isFull() then
    self.score += 1
  end
end

function Bucket:isFull()
  return self.score >= 8
end

function Bucket:draw(row)
  gfx.drawArc(
    29,
    29 + (row - 1) * 60,
    22,
    self.angleOffset - 45 + self.angle,
    self.angleOffset + 235 + self.angle)

  if self.score > 0 then
    gfx.fillCircleAtPoint(29, 29 + (row - 1) * 60, self.score * 2)
  end
end

