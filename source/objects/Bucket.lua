import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/timer'
import 'CoreLibs/easing'

local MAX_BUCKET_SCORE <const> = 8
local RADIUS <const> = 22
local OPENING_ADJUSTMENT <const> = 10

local gfx <const> = playdate.graphics

class('Bucket').extends()

function Bucket:init(row, angle)
  Bucket.super.init(self)

  self.angle = angle
  self.crank = 0
  self.score = 0
  self.temporaryScore = 0

  self.radiusTimer = playdate.timer.new(
    250,
    0,
    RADIUS,
    playdate.easingFunctions.inCubic)
  self.rowTimer = playdate.timer.new(
    250,
    row,
    row,
    playdate.easingFunctions.outCubic)
  self.openingTimer = playdate.timer.new(
    250,
    45,
    45,
    playdate.easingFunctions.outCubic)

  self.angleTimer = nil
  self.scoreTimer = nil
end

function Bucket:remove()
  self.radiusTimer:remove()
  self.rowTimer:remove()
  self.openingTimer:remove()
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
  local angle = (self.crank + self.angle) % 360 - 180

  -- The opening is 45 degrees, but we need to adjust it a bit because food has
  -- non-zero radius
  local opening = math.max(0, self.openingTimer.value - OPENING_ADJUSTMENT)

  return -opening < angle and angle < opening
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

function Bucket:moveToRow(row)
  self.rowTimer:remove()
  self.rowTimer = playdate.timer.new(
    250,
    self.rowTimer.value,
    row,
    playdate.easingFunctions.outCubic)
end

function Bucket:setOpeningAngle(newAngle)
  self.openingTimer:remove()
  self.openingTimer = playdate.timer.new(
    250,
    self.openingTimer.value,
    newAngle,
    playdate.easingFunctions.outCubic)
end

function Bucket:getX()
  return 29
end

function Bucket:getOpening()
  return 24
end

function Bucket:getY()
  return 29 + (self.rowTimer.value - 1) * 60
end

function Bucket:draw(row)
  local x = self:getX()
  local y = self:getY()

  gfx.drawArc(
    x,
    y,
    self.radiusTimer.value,
    self.angle - 90 + self.openingTimer.value + self.crank,
    self.angle + 270 - self.openingTimer.value + self.crank)

  local displayScore = self.score + self.temporaryScore
  if displayScore > 0 then
    gfx.fillCircleAtPoint(x, y, displayScore * 2)
  end
end
