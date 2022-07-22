--
-- libraries
--

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/constants'
require 'src/Entity'
require 'src/Tree'
require 'src/Predator'
require 'src/Prey'
require 'src/StateMachine'
require 'src/Player'
require 'src/Util'
require 'src/World'
require 'src/Menu'


require 'src/states/BaseState'

require 'src/states/game/GameOverState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/tilesheet.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['biomes'] = love.graphics.newImage('graphics/biomes.png'),
    ['player'] = love.graphics.newImage('graphics/character.png'),
    ['entities'] = love.graphics.newImage('graphics/entities.png'),
    ['vignette'] = love.graphics.newImage('graphics/lowHp.png'),
    ['icons'] = love.graphics.newImage('graphics/hearts.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['bigTiles'] = GenerateQuads(gTextures['tiles'], 64, 64),
    ['biomes'] = GenerateQuads(gTextures['biomes'], 16, 16),
    ['player'] = GenerateQuads(gTextures['player'], 32, 32),
    ['entity'] = GenerateQuads(gTextures['entities'], 32, 32),
    ['icon'] = GenerateQuads(gTextures['icons'], 16, 16),
    ['big_icon'] = GenerateQuads(gTextures['icons'], 32, 32)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 6),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['gothic-small'] = love.graphics.newFont('fonts/GothicPixels.ttf', 8),
    ['gothic-medium'] = love.graphics.newFont('fonts/GothicPixels.ttf', 16),
    ['gothic-large'] = love.graphics.newFont('fonts/GothicPixels.ttf', 32),
    ['zelda'] = love.graphics.newFont('fonts/zelda.otf', 64),
    ['zelda-small'] = love.graphics.newFont('fonts/zelda.otf', 32),
    ['start'] = love.graphics.newFont('fonts/PressStart2P.ttf', 30),
    ['startSmall'] = love.graphics.newFont('fonts/PressStart2P.ttf', 10),
}

gSounds = {
    ['swipe'] = love.audio.newSource('sounds/attack.wav'),
    ['hit'] = love.audio.newSource('sounds/hit.wav'),
    ['ding'] = love.audio.newSource('sounds/ding.wav'),
    ['death'] = love.audio.newSource('sounds/dead.wav'),
    ['night'] = love.audio.newSource('sounds/night.mp3'),
    ['music'] = love.audio.newSource('sounds/music.mp3')
}