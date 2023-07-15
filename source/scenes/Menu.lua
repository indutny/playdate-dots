import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'CoreLibs/ui'

import 'scenes/Scene'
import 'scenes/Game'

local gfx <const> = playdate.graphics
local titleImage = gfx.image.new('images/title')

class('Menu').extends(Scene)

function Menu:init()
  Menu.super.init(self)
  gfx.setLineWidth(2)
end

function Menu:update()
  titleImage:draw(0, 0)

  gfx.drawTextAligned(
    'Press Ⓐ to Start',
    200,
    165,
    kTextAlignment.center)
end

function Menu:AButtonUp()
  setCurrentScene(Game())
end
