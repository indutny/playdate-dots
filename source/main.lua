import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"

import "scenes/Game"

local gfx <const> = playdate.graphics

local scene = nil

function initGame()
  math.randomseed(playdate.getSecondsSinceEpoch())
  playdate.ui.crankIndicator:start()

  scene = Game()

  foodTimer = playdate.timer.keyRepeatTimerWithDelay(1000, 1000, addFood)

  gfx.setLineWidth(4)
end

initGame()

function playdate.update()
  scene:update()

  -- Update internal playdate state

  playdate.timer.updateTimers()
  if playdate.isCrankDocked() then
    playdate.ui.crankIndicator:update()
  end
end

function playdate.crankDocked()
  playdate.ui.crankIndicator:start()
end

function playdate.debugDraw()
  playdate.drawFPS(0, 0)
end
