import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/timer'
import 'CoreLibs/easing'

local MAX_BUCKET_SCORE <const> = 8

local gfx <const> = playdate.graphics

class('Bucket').extends()

function Bucket:init(row, angle)
  Bucket.super.init(self)

  self.row = row
  self.angle = angle
  self.crank = 0
  self.score = 0
  self.temporaryScore = 0

  self.angleTimer = nil
  self.scoreTimer = nil
end

function Bucket:remove()
  if self.angleTimer ~= nil then
    self.angleTimer:remove()
  end
  if self.scoreTimer ~= nil then
    self.scoreTimer:remove()
  end
end

function Bucket:update(crank)
  self.crank = crank
end

function Bucket:isOpen()
  local angle = (self.crank + self.angle) % 360

  -- The opening is 45 degrees, but we need to adjust it a bit because food has
  -- non-zero radius
  return 145 < angle and angle < 215
end

function Bucket:feed()
  if not self:isFull() then
    self:updateScoreTo(self.score + 1, 125)
  end
end

function Bucket:isFull()
  return self.score >= MAX_BUCKET_SCORE
end

function Bucket:emptyAndRotate(degrees, duration)
  if self.angleTimer ~= nil then
    self.angleTimer:remove()
  end
  local newAngle = (self.angle + math.max(0, degrees)) % 360

  self.angleTimer = playdate.timer.new(
    duration,
    self.angle,
    self.angle + (math.random(0, 1) - 0.5) * 2 * degrees,
    playdate.easingFunctions.inOutCubic)

  self.angleTimer.updateCallback = function(timer)
    self.angle = timer.value
  end

  self:updateScoreTo(0, duration)
end

function Bucket:updateScoreTo(newValue, duration)
  if self.scoreTimer ~= nil then
    self.scoreTimer:remove()
  end
  self.scoreTimer = playdate.timer.new(
    duration,
    self.score - newValue,
    0,
    playdate.easingFunctions.outCubic)

  self.scoreTimer.updateCallback = function(timer)
    self.temporaryScore = timer.value
  end

  self.temporaryScore = self.score - newValue
  self.score = newValue
end

function Bucket:getX()
  return 29
end

function Bucket:getOpening()
  return 24
end

function Bucket:getY()
  return 29 + (self.row - 1) * 60
end

function Bucket:draw(row)
  local x = self:getX()
  local y = self:getY()

  gfx.drawArc(
    x,
    y,
    22,
    self.angle - 45 + self.crank,
    self.angle + 235 + self.crank)

  local displayScore = self.score + self.temporaryScore
  if displayScore > 0 then
    gfx.fillCircleAtPoint(x, y, displayScore * 2)
  end
end
