import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'CoreLibs/ui'

import 'scenes/Scene'
import 'scenes/Menu'

local gfx <const> = playdate.graphics
local numeralFont = gfx.font.new('fonts/Roobert-24-Numerals')

numeralFont:setTracking(6)

class('GameOver').extends(Scene)

function GameOver:init(score)
  GameOver.super.init(self)

  local data = playdate.datastore.read()
  if data == nil then
    data = { highScore = score }
  elseif data.highScore == nil then
    data.highScore = score
  else
    data.highScore = math.max(score, data.highScore)
  end
  playdate.datastore.write(data)

  self.score = score
  self.highScore = data.highScore

  self.scoreTimer = playdate.timer.new(
    750,
    0,
    score,
    playdate.easingFunctions.linear)

  gfx.setLineWidth(2)
end

function GameOver:update()
  local paddedScore = tostring(math.floor(self.scoreTimer.value))
  while #paddedScore < 4 do
    paddedScore = '0' .. paddedScore
  end
  numeralFont:drawTextAligned(
    paddedScore,
    200,
    120 - numeralFont:getHeight() / 2,
    kTextAlignment.center)

  if self.scoreTimer.timeLeft == 0 then
    if self.score == self.highScore then
      gfx.drawTextAligned(
        'New High Score: ' .. self.highScore .. '!',
        200,
        150,
        kTextAlignment.center)
    else
      gfx.drawTextAligned(
        'High Score: ' .. self.highScore,
        200,
        150,
        kTextAlignment.center)
    end

    gfx.drawTextAligned(
      'Press Ⓐ to Play Again',
      200,
      185,
      kTextAlignment.center)
  end
end

function GameOver:AButtonUp()
  setCurrentScene(Menu())
end

function GameOver:BButtonUp()
  setCurrentScene(Menu())
end
