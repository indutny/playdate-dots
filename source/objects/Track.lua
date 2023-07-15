import 'CoreLibs/object'

local FPS <const> = 30;

local bassDrumSample = playdate.sound.sampleplayer.new(
  'sounds/bass-drum-sample.wav')
local clapSample = playdate.sound.sampleplayer.new(
  'sounds/clap-sample.wav')
local hhSample = playdate.sound.sampleplayer.new(
  'sounds/hh-sample.wav')

local leadSample = playdate.sound.sample.new(
  'sounds/lead-sample.wav')
local bassSample = playdate.sound.sample.new(
  'sounds/bass-sample.wav')

class('Track').extends()

local leadNotes = {
  {'E3', 1, 4},
  {'G3', 1, 3},
  {'Bb3', 1, 2},
  {'A3', 1, 1},
  {'F3', 1, 2},
  {'E3', 1, 3},
  {'D3', 1, 4},
  {'C3', 1, 1},

  {'C3', 1, 1},
  {'E3', 1, 4},
  {'Bb3', 1, 3},
  {'C4', 1, 2},
  {'D4', 1, 1},
  {'C4', 1, 2},
  {'D4', 1, 1},
  {'Eb4', 1, 4},

  {'E4', 1, 3},
  {'F4', 1, 2},
  {'D4', 1, 3},
  {'C4', 1, 4},
  {'E4', 2, 3},
  {'C4', 2, 4},

  {'E4', 1, 3},
  {'F4', 1, 2},
  {'A3', 1, 3},
  {'B3', 1, 2},
  {'Db4', 1, 1},
  {'D4', 1, 4},
  {'B3', 1, 1},
  {'E4', 1, 4},
}

local bassNotes = {
  -- First melody
  {'C3', 1 / 4},
  {'C3', 1 / 4},
  {nil, 1 / 4},
  {'C3', 1 / 4},
  {'C3', 1 / 4},
  {nil, 3 / 4},

  {'F3', 1 / 4},
  {nil, 1 / 8},
  {'F3', 1 / 4},
  {nil, 1 / 4},
  {'F3', 1 / 8},
  {'F3', 1 / 4},
  {'F3', 1 / 4},
  {nil, 1 / 2},

  {'A3', 1 / 4},
  {'A3', 1 / 4},
  {nil, 1 / 4},
  {'A3', 1 / 4},
  {'A3', 1 / 4},
  {nil, 3 / 4},

  {'G3', 1 / 4},
  {nil, 1 / 8},
  {'G3', 1 / 4},
  {nil, 1 / 4},
  {'G3', 1 / 8},
  {'G3', 1 / 4},
  {'G3', 1 / 4},
  {nil, 1 / 2},

  -- Second melody
  {'C3', 1 / 4},
  {'C3', 1 / 4},
  {nil, 1 / 4},
  {'C3', 1 / 4},
  {'C3', 1 / 4},
  {nil, 3 / 4},

  {'F3', 1 / 4},
  {nil, 1 / 8},
  {'F3', 1 / 4},
  {nil, 1 / 4},
  {'F3', 1 / 8},
  {'F3', 1 / 4},
  {'F3', 1 / 4},
  {nil, 1 / 2},

  {'A3', 1 / 4},
  {'A3', 1 / 4},
  {nil, 1 / 4},
  {'A3', 1 / 4},
  {'A3', 1 / 4},
  {nil, 3 / 4},

  {'Ab3', 1 / 4},
  {nil, 1 / 8},
  {'Ab3', 1 / 4},
  {nil, 1 / 4},
  {'Ab3', 1 / 8},
  {'Ab3', 1 / 4},
  {'Ab3', 1 / 4},
  {nil, 1 / 2},

  -- Third melody
  {'D3', 1 / 4},
  {'D3', 1 / 4},
  {nil, 1 / 4},
  {'D3', 1 / 4},
  {'D3', 1 / 4},
  {nil, 3 / 4},

  {'F3', 1 / 4},
  {nil, 1 / 8},
  {'F3', 1 / 4},
  {nil, 1 / 4},
  {'F3', 1 / 8},
  {'F3', 1 / 4},
  {'F3', 1 / 4},
  {nil, 1 / 2},

  {'A3', 1 / 4},
  {'A3', 1 / 4},
  {nil, 1 / 4},
  {'A3', 1 / 4},
  {'A3', 1 / 4},
  {nil, 3 / 4},

  {'F3', 1 / 4},
  {nil, 1 / 8},
  {'F3', 1 / 4},
  {nil, 1 / 4},
  {'F3', 1 / 8},
  {'F3', 1 / 4},
  {'F3', 1 / 4},
  {nil, 1 / 2},

  -- Fourth melody
  {'D3', 1 / 4},
  {'D3', 1 / 4},
  {nil, 1 / 4},
  {'D3', 1 / 4},
  {'D3', 1 / 4},
  {nil, 3 / 4},

  {'F3', 1 / 4},
  {nil, 1 / 8},
  {'F3', 1 / 4},
  {nil, 1 / 4},
  {'F3', 1 / 8},
  {'F3', 1 / 4},
  {'F3', 1 / 4},
  {nil, 1 / 2},

  {'G3', 1 / 4},
  {'G3', 1 / 4},
  {nil, 1 / 4},
  {'G3', 1 / 4},
  {'G3', 1 / 4},
  {nil, 3 / 4},

  {'D3', 1 / 4},
  {nil, 1 / 8},
  {'D3', 1 / 4},
  {nil, 1 / 4},
  {'D3', 1 / 8},
  {'D3', 1 / 4},
  {'D3', 1 / 4},
  {nil, 1 / 2},
}

local drumNotes = {
  {{'hh', 'b'}, 1 / 4},
  {{'b'},  1 / 4},
  {{'hh'}, 1 / 4},
  {{'b'},  1 / 4},
  {{'hh', 'c'}, 1 / 8},
  {{'b'}, 3 / 8},
  {{'hh', 'b'},  1 / 2},

  {{'hh', 'b'}, 3 / 8},
  {{'b'},  1 / 8},
  {{'hh'}, 3 / 8},
  {{'b'},  1 / 8},
  {{'hh', 'c'}, 1 / 4},
  {{'b'}, 1 / 4},
  {{'hh'}, 1 / 4},
  {{'b'},  1 / 4},
}

function Track:init(quarterBar, speed)
  self.quarterBar = quarterBar
  self.speed = speed
  self.leadCountdown = 0
  self.bassCountdown = 405 - 30
  self.drumCountdown = 405 - 30 - 4 * quarterBar

  self.displayedNote = 1
  self.playedNote = 1
  self.bassNote = 1
  self.drumNote = 1

  self.leadSynth = playdate.sound.synth.new(leadSample)
  self.leadSynth:setADSR(0.005, 0, 1, 0.1)

  self.bassSynth = playdate.sound.synth.new(bassSample)
  self.bassSynth:setADSR(0.005, 0, 1, 0.1)
end

function Track:remove()
  self.leadSynth:stop()
  self.bassSynth:stop()
end

function Track:update()
  self.drumCountdown -= self.speed
  if self.drumCountdown <= 0 then
    local note = drumNotes[self.drumNote]
    self.drumNote = 1 + (self.drumNote % #drumNotes)
    self.drumCountdown += note[2] * self.quarterBar
    for _, instr in ipairs(note[1]) do
      if instr == 'hh' then
        hhSample:play()
      elseif instr == 'b' then
        bassDrumSample:play()
      elseif instr == 'c' then
        clapSample:play()
      end
    end
  end

  self.bassCountdown -= self.speed
  if self.bassCountdown <= 0 then
    local note = bassNotes[self.bassNote]
    self.bassNote = 1 + (self.bassNote % #bassNotes)
    self.bassCountdown += note[2] * self.quarterBar
    if note[1] ~= nil then
      self.bassSynth:playNote(note[1], 1, self.quarterBar * note[2] / self.speed / FPS)
    end
  end

  self.leadCountdown -= self.speed
  if self.leadCountdown <= 0 then
    local note = leadNotes[self.displayedNote]
    self.displayedNote = 1 + (self.displayedNote % #leadNotes)
    self.leadCountdown += note[2] * self.quarterBar
    return note[3]
  end

  return nil
end

function Track:setSpeed(speed)
  self.speed = speed
end

function Track:playNote()
  local note = leadNotes[self.playedNote]
  self.leadSynth:playNote(note[1], 1, self.quarterBar * note[2] / self.speed / FPS)
  self.playedNote = 1 + (self.playedNote % #leadNotes)
end

function Track:skipNote()
  self.playedNote = 1 + (self.playedNote % #leadNotes)
end
