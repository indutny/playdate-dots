import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"

import "Bucket"
import "Food"

local MAX_LIFE <const> = 5
local gfx <const> = playdate.graphics

local buckets = nil
local food = nil
local foodTimer = nil
local score = nil
local life = nil

function addFood()
  table.insert(food, Food(math.random(1, 4)))
end

function initGame()
  math.randomseed(playdate.getSecondsSinceEpoch())
  playdate.ui.crankIndicator:start()

  buckets = {Bucket(0), Bucket(90), Bucket(180), Bucket(270)}
  food = {}
  score = 0
  life = MAX_LIFE

  foodTimer = playdate.timer.keyRepeatTimerWithDelay(1000, 1000, addFood)

  gfx.setLineWidth(4)
end

initGame()

function playdate.update()
  local crank = playdate.getCrankPosition()

  -- Update objects

  for _, bucket in ipairs(buckets) do
    if bucket ~= nil then
      bucket:setAngle(crank)
    end
  end

  for i = #food, 1, -1 do
    local f = food[i]
    local b = buckets[f.row]

    f:move(b:isOpen())

    if f:isDead() then
      if f.isConsumed then
        -- TODO(indutny): sound
        b:feed()
        score += 1
      else
        life -= 1
      end
      table.remove(food, i)
    end
  end

  for row = #buckets, 1, -1 do
    local bucket = buckets[row]
    if bucket:isFull() then
      -- TODO(indutny): sound and animation
      local newBucket = Bucket(math.random(0, 3) * 90)
      newBucket:setAngle(crank)
      buckets[row] = newBucket
      if life < MAX_LIFE then
        life += 1
      end

      -- Remove all food on this row
      for i = #food, 1, -1 do
        local f = food[i]
        if f.row == row then
          table.remove(food, i)
        end
      end
    end
  end

  -- Draw objects

  gfx.clear()

  for row, bucket in ipairs(buckets) do
    bucket:draw(row)
  end
  for _, f in ipairs(food) do
    f:draw()
  end

  gfx.drawTextAligned(
    "*Score: " .. tostring(score) .. "*",
    398,
    2,
    kTextAlignment.right)

  gfx.drawTextAligned(
    "*Life: " .. tostring(life) .. "*",
    398,
    222,
    kTextAlignment.right)

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
