import 'CoreLibs/object'

local FPS <const> = 30;

local bassDrumSample = playdate.sound.sampleplayer.new(
  'sounds/bass-drum-sample.wav')
local clapSample = playdate.sound.sampleplayer.new(
  'sounds/clap-sample.wav')
local hhSample = playdate.sound.sampleplayer.new(
  'sounds/hh-sample.wav')

class('Track').extends()

local leadNotes = {
  {'Eb4', 1, 2},
  {'D4', 1, 3},

  {'F4', 1, 1},
  {'E4', 1, 2},

  {'C4', 1, 4},
  {'D4', 1, 3},

  {'D4', 1, 3},
  {'Eb4', 1, 2},
}

local bassNotes = {
  {nil,  1 / 8},
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
  self.bassCountdown = 405 - 29 - 4 * quarterBar
  self.drumCountdown = 405 - 29 - 4 * quarterBar

  self.displayedNote = 1
  self.playedNote = 1
  self.bassNote = 1
  self.drumNote = 1

  self.leadSynth = playdate.sound.synth.new(playdate.sound.kWaveTriangle)
  self.leadSynth:setADSR(0.005, 0, 1, 0.1)

  self.bassSynth = playdate.sound.synth.new(playdate.sound.kWaveSine)
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
      self.bassSynth:playNote(note[1], 0.5, self.quarterBar * note[2] / self.speed / 2 / FPS)
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
  self.leadSynth:playNote(note[1], 0.5, self.quarterBar / self.speed / 2 / FPS)
  self.playedNote = 1 + (self.playedNote % #leadNotes)
end

function Track:skipNote()
  self.playedNote = 1 + (self.playedNote % #leadNotes)
end
