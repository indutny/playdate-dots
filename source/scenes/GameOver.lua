import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"

import "scenes/Scene"
import "scenes/Menu"

local gfx <const> = playdate.graphics

class("GameOver").extends(Scene)

function GameOver:init(score)
  GameOver.super.init(self)

  self.score = score
end

function GameOver:update()
  gfx.drawTextAligned(
    "*Game over*",
    200,
    105,
    kTextAlignment.center)
  gfx.drawTextAligned(
    "*Score: " .. tostring(self.score) .."*",
    200,
    125,
    kTextAlignment.center)
end

function GameOver:AButtonUp()
  setCurrentScene(Menu())
end

function GameOver:BButtonUp()
  setCurrentScene(Menu())
end
