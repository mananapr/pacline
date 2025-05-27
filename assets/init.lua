local g, a = love.graphics, love.audio

local ASSETS_DIR = "assets/"
local FONT_MONOGRAM_TTF = ASSETS_DIR .. "monogram.ttf"

local SOUND_POINT = ASSETS_DIR .. "point.wav"
local SOUND_POWERPOINT = ASSETS_DIR .. "powerpoint.wav"
local SOUND_VULNERABLE = ASSETS_DIR .. "vulnerable.wav"
local SOUND_GAMEOVER = ASSETS_DIR .. "gameover.wav"

local SPRITE = function(name)
  return g.newImage(ASSETS_DIR .. name)
end

return {
  font = {
    lg = g.newFont(FONT_MONOGRAM_TTF, 52),
    md = g.newFont(FONT_MONOGRAM_TTF, 32),
  },
  sound = {
    point = a.newSource(SOUND_POINT, "static"),
    powerpoint = a.newSource(SOUND_POWERPOINT, "static"),
    vulnerable = a.newSource(SOUND_VULNERABLE, "static"),
    gameover = a.newSource(SOUND_GAMEOVER, "static"),
  },
  sprite = {
    pacman = {
      right = {
        SPRITE("pacman_right_1.png"),
        SPRITE("pacman_right_2.png"),
        SPRITE("pacman_right_3.png"),
      },
      left = {
        SPRITE("pacman_left_1.png"),
        SPRITE("pacman_left_2.png"),
        SPRITE("pacman_left_3.png"),
      },
    },
    ghost = {
      active = SPRITE("ghost.png"),
      vulnerable = SPRITE("blue_ghost.png"),
    },
    keys = SPRITE("keys.png"),
  },
}
