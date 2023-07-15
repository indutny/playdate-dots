import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'CoreLibs/ui'

import 'scenes/Scene'
import 'scenes/Menu'

local gfx <const> = playdate.graphics
local numeralFont = gfx.font.new('fonts/Roobert-24-Medium-Numerals')

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

  gfx.setLineWidth(2)
end

function GameOver:update()
  numeralFont:drawTextAligned(
    'Score: ' .. tostring(self.score),
    200,
    120 - numeralFont:getHeight() / 2,
    kTextAlignment.center)

  gfx.drawTextAligned(
    'High Score: ' .. tostring(self.highScore),
    200,
    150,
    kTextAlignment.center)

  gfx.drawTextAligned(
    'Press Ⓐ to Play Again',
    200,
    185,
    kTextAlignment.center)
end

function GameOver:AButtonUp()
  setCurrentScene(Menu())
end

function GameOver:BButtonUp()
  setCurrentScene(Menu())
end
