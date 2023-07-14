import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'CoreLibs/ui'

import 'scenes/Scene'
import 'scenes/Game'

local gfx <const> = playdate.graphics

class('Menu').extends(Scene)

function Menu:init()
  Menu.super.init(self)
end

function Menu:update()
  gfx.drawTextAligned(
    '*Press (A) to Start*',
    200,
    115,
    kTextAlignment.center)
end

function Menu:AButtonUp()
  setCurrentScene(Game())
end
