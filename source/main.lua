import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"

import "Bucket"
import "Food"

local gfx <const> = playdate.graphics

local buckets = nil
local food = nil
local foodTimer = nil

function addFood()
  table.insert(food, Food(math.random(1, 4)))
end

function playdate.crankDocked()
  playdate.ui.crankIndicator:start()
end

function initGame()
  math.randomseed(playdate.getSecondsSinceEpoch())
  playdate.ui.crankIndicator:start()

  buckets = {Bucket(0), Bucket(90), Bucket(180), Bucket(270)}
  food = {}

  foodTimer = playdate.timer.keyRepeatTimerWithDelay(1000, 1000, addFood)

  gfx.setLineWidth(4)
end

initGame()

function playdate.update()
  local crank = playdate.getCrankPosition()

  gfx.clear()

  for i, bucket in ipairs(buckets) do
    bucket:setAngle(crank)
    bucket:draw(i)
  end

  -- TODO(indutny): if bucket is full - remove it with animation and sound and
  -- add a new bucket instead of it.

  for i = #food, 1, -1 do
    f = food[i]
    local b = buckets[f.row]

    f:move(b:isOpen())
    f:move(b:isOpen())
    f:move(b:isOpen())

    if f:isDead() then
      if f.isConsumed then
        -- TODO(indutny): sound
        b:feed()
      end
      table.remove(food, i)
    else
      f:draw()
    end
  end

  playdate.drawFPS(0, 0)
  playdate.timer.updateTimers()
  if playdate.isCrankDocked() then
    playdate.ui.crankIndicator:update()
  end
end
