
PlayState = Class{__includes = BaseState}

function PlayState:init()

end

function PlayState:enter(params)
    self.seed = 62786742396423798
    --TODO(caille): create a player
    self.player = Player {
        
        x = VIRTUAL_WIDTH/2,
        y = VIRTUAL_HEIGHT/2,
        
        width = 16,
        height = 16,

        hitWidth = 14,
        hitHeight = 28,

        -- one heart == 2 health
        health = 100,

        -- rendering and collision offset for spaced sprites
        offsetY = 5
    }
    self.world = World{
        seed=self.seed,
        player = self.player
    }
    --low, high = love.math.getRandomSeed()
    --TODO(caille): create a world
    --self.dungeon = Dungeon(self.player)
    self.paused = false
    self.logged = false
    self.playerpoints = 0
    self.t = 0
    gSounds['music']:setLooping(true)
    gSounds['music']:play()
    if self.paused then
        love.audio.pause()
    end
    self.wasEpressed = false
end

function PlayState:update(dt)
    if love.keyboard.isDown('e') and not self.wasEpressed then
        self.paused = not self.paused
    end
    if self.paused then
        self.menu = Menu{
            x=self.player.x - VIRTUAL_WIDTH/2 + 5,
            y=self.player.y - VIRTUAL_HEIGHT/2 + 5}
            self.player.stats = self.menu:update(dt,self.player.stats)
    end
    self.t = self.t + dt
    if not self.paused then
        self.player:update(dt)
    end
    if love.keyboard.wasPressed('escape') and not self.paused then
        love.event.quit()
    end
    if love.keyboard.wasPressed('escape') and self.paused then
        self.paused = false
    end

    if not self.paused then
        self.world:update(dt)
    end
    self.wasEpressed = love.keyboard.isDown('e')
end

function PlayState:render()
    -- render dungeon and all entities separate from hearts GUI
    love.graphics.push()
    love.graphics.translate(-self.player.x,-self.player.y)
    love.graphics.translate(VIRTUAL_WIDTH/2,VIRTUAL_HEIGHT/2)
    self.world:render(self.player.x,self.player.y)
    if self.paused then
        self.menu:render()
    end
    love.graphics.pop()
end