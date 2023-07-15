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

  self.fadeIn = playdate.timer.new(
    250,
    0,
    1)
end

function Menu:remove()
  self.fadeIn:remove()
end

function Menu:update()
  titleImage:drawFaded(
    0, 0, self.fadeIn.value, gfx.image.kDitherTypeFloydSteinberg)

  if self.fadeIn.value == 1 then
    gfx.drawTextAligned(
      'Press Ⓐ to Start',
      200,
      165,
      kTextAlignment.center)
  end
end

function Menu:AButtonUp()
  setCurrentScene(Game())
end
