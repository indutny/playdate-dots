import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/frameTimer"
import "CoreLibs/ui"

import "scenes/Menu"
import "scenes/Game"
import "scenes/GameOver"

local gfx <const> = playdate.graphics

local scene = nil

function initGame()
  math.randomseed(playdate.getSecondsSinceEpoch())
  playdate.ui.crankIndicator:start()

  scene = Menu()
end

function setCurrentScene(newScene)
  scene:remove()
  scene = newScene
end

initGame()

function playdate.update()
  gfx.clear()

  scene:update()

  -- Update internal playdate state

  playdate.timer.updateTimers()
  playdate.frameTimer.updateTimers()
  if playdate.isCrankDocked() then
    playdate.ui.crankIndicator:update()
  end
end

function playdate.AButtonUp()
  scene:AButtonUp()
end

function playdate.BButtonUp()
  scene:BButtonUp()
end

function playdate.crankDocked()
  playdate.ui.crankIndicator:start()
end

function playdate.debugDraw()
  playdate.drawFPS(0, 0)
end
