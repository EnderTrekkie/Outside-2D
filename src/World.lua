World = Class{}

biomeLookup = {
    {1, 1, 1, 1, 9, 9, 9, 9, 9, 9,10,10,10,10, 8, 8, 8, 8, 8, 8},
    {1, 1, 1, 1, 9, 9, 9, 9, 9, 9,10,10,10,10, 8, 8, 8, 8, 8, 8},
    {1, 1, 1, 1, 9, 9, 9, 9, 9, 9,10,10,10,10, 8, 8, 8, 8, 8, 8},
    {1, 1, 1, 1, 9, 9, 9, 9, 9, 9,10,10,10,10, 8, 8, 8, 8, 8, 8},
    {1, 1, 1, 1, 9, 9, 9, 9, 9, 9,10,10,10,10, 8, 8, 8, 8, 8, 8},
    {1, 1, 1, 1, 9, 9, 9, 9, 9, 9,10,10,10,10, 8, 8, 8, 8, 8, 8},
    {1, 1, 1, 1, 9, 9, 9, 9, 9, 9,10,10,10,10, 8, 8, 8, 8, 8, 8},
    {2, 1, 1, 1, 9, 9, 9, 9, 9, 9,10,10,10,10, 8, 8, 8, 8, 8, 8},
    {2, 2, 2, 2,11, 4, 4, 4, 4, 4, 3, 3, 3, 3, 7, 7, 7, 7, 7, 7},
    {2, 2, 2, 2,11, 4, 4, 4, 4, 4, 3, 3, 3, 3, 7, 7, 7, 7, 7, 7},
    {2, 2, 2, 2,11, 4, 4, 4, 4, 4, 3, 3, 3, 3, 7, 7, 7, 7, 7, 7},
    {2, 2, 2, 2,11, 4, 4, 4, 4, 4, 3, 3, 3, 3, 7, 7, 7, 7, 7, 7},
    {2, 2, 2, 2,11, 4, 4, 4, 4, 4, 3, 3, 3, 3, 7, 7, 7, 7, 7, 7},
    {2, 2, 2, 2,11, 4, 4, 4, 4,12,12,12,12,12, 7, 7, 7, 7, 7, 7},
    {2, 2, 2, 2,11, 4, 4, 4, 4,12,12,12,12,12, 7, 7, 7, 7, 7, 7},
    {2, 2, 2, 2, 5, 5, 5, 5, 5,12,12,12,12,12, 7, 7, 7, 7, 7, 7},
    {2, 2, 2, 2, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7},
    {2, 2, 2, 2, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7},
    {2, 2, 2, 2, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7},
    {2, 2, 2, 2, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7} 
}
tileToBiome = {
    [1] = 'Glacier',
    [2] = 'Ocean',
    [3] = 'Forest',
    [4] = 'Plains',
    [5] = 'Desert',
    [6] = 'Wastes',
    [7] = 'Mountains',
    [8] = 'Snowy Mountains',
    [9] = 'Snowy Plains',
    [10] = 'Snow_Forest',
    [11] = 'Beach',
    [12] = 'Savana',}
function World:tileToBiome(t)
    return tileToBiome[t]
end

function World:init(def)
    self.darkness = 0
    self.seed = def.seed
    self.t = 0
    self.tileCache = {}
    self.watermark = 0
    self.entities = {}
    self.player = def.player
    self.spawnTimer = math.random(0.5,2.5)
    self.iCounter = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    self.jCounter = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    self.lightOpacity = 0
    self.tweenLock = false
end

function World:getVector(x,y)
    math.randomseed(x*self.seed)
    local temp = math.random(y*500)
    math.randomseed(temp)
    return math.random(),math.random()
end

function World:getChunkBoundaries(x,y)
    local chunkX=math.floor(x/CHUNK_SIZE)
    local chunkY=math.floor(y/CHUNK_SIZE)
    ChunksX = {(chunkX-1)*CHUNK_SIZE,(chunkX)*CHUNK_SIZE,(chunkX+1)*CHUNK_SIZE,(chunkX+2)*CHUNK_SIZE}
    ChunksY = {(chunkY-1)*CHUNK_SIZE,(chunkY)*CHUNK_SIZE,(chunkY+1)*CHUNK_SIZE,(chunkY+2)*CHUNK_SIZE}
    return ChunksX, ChunksY
end

function World:getFrameForij(i,j)
    local ni = math.floor(i*20)+1
    local nj = math.floor(j*20)+1
    if ni < 1 or ni > 20 or nj < 1 or nj > 20 then
        ni = 1
        nj = 1
    end
    return biomeLookup[ni][nj]  
end

function World:interpolate(m1,m2,z1,z2,z)
    local d = math.abs(z1-z2)
    local dz1 = math.abs(z1-z)
    local dz2 = math.abs(z2-z)
    return m1*(1-dz1/d)+(1-dz2/d)*m2
end

function World:dostuff(tli, tlj,tlx,tly,tri, trj,trx,try,bli,blj,blx,bly,bri,brj,brx,bry,x,y)
    local ti = self:interpolate(tli,tri,tlx,trx,x)
    local bi = self:interpolate(bli,bri,blx,brx,x)
    local rif = self:interpolate(ti,bi,tly,bly,y)
    local tj = self:interpolate(tlj,trj,tlx,trx,x)
    local bj = self:interpolate(blj,brj,blx,brx,x)
    local rjf = self:interpolate(tj,bj,tly,bly,y)
    return rif,rjf
end

function World:getTileFrame(x,y)
    local key = tostring(x) .. ' ' .. tostring(y)
    if not self.tileCache[key] then

        local tlx = math.floor(x/CHUNK_SIZE) * CHUNK_SIZE
        local tly = math.floor(y/CHUNK_SIZE) * CHUNK_SIZE
        local trx = tlx+CHUNK_SIZE
        local try = tly
        local blx = tlx
        local bly = tly+CHUNK_SIZE
        local brx = tlx+CHUNK_SIZE
        local bry = tly+CHUNK_SIZE
        local tli, tlj = self:getVector(tlx,tly)
        local tri, trj = self:getVector(trx,try)
        local bli, blj = self:getVector(blx,bly)
        local bri, brj = self:getVector(brx,bry)
        local rif, rjf = self:dostuff(tli, tlj,tlx,tly,tri, trj,trx,try,bli,blj,blx,bly,bri,brj,brx,bry,x,y)
        local tileFrame = self:getFrameForij(rif,rjf)

        self.iCounter[round(rif*20)+1] = self.iCounter[round(rif*20)+1] + 1
        self.jCounter[round(rjf*20)+1] = self.jCounter[round(rjf*20)+1] + 1
        self.tileCache[key] = {['f'] = tileFrame, ['t'] = self.t}
    end
    self.tileCache[key].t = self.t
    self:cleanUpCache()
    return self.tileCache[key].f
end

function World:cleanUpCache()
    if self.watermark<self.t-60 then
        self.watermark = self.t
        for key, value in pairs(self.tileCache) do
            if value.t and value.t < self.t-60 then
                self.tileCache[key] = nil
            end
        end
    end
end

function World:despawn()
    for i,entity in pairs(self.entities) do
        if entity.x<self.player.x-VIRTUAL_WIDTH/1.5 or 
           entity.y<self.player.y-VIRTUAL_HEIGHT/1.5 or 
           entity.x>self.player.x+VIRTUAL_WIDTH/1.5 or 
           entity.y>self.player.y+VIRTUAL_HEIGHT/1.5 then
            table.remove(self.entities,i)
        end
    end
end

function World:sprinkleMobs()
    local numTiles = 0
    local startX,startY = math.floor(self.player.x/TILE_SIZE)*TILE_SIZE, math.floor(self.player.y/TILE_SIZE)*TILE_SIZE
    for x=startX-VIRTUAL_WIDTH/2-TILE_SIZE, startX+VIRTUAL_WIDTH/2+TILE_SIZE,TILE_SIZE do
        for y=startY-VIRTUAL_HEIGHT/2-TILE_SIZE, startY+VIRTUAL_HEIGHT/2+TILE_SIZE,TILE_SIZE do
            numTiles = numTiles + 1
        end
    end
    local numTrees = 0
    for i,entity in pairs(self.entities) do
        if entity.type == 'tree' then
            numTrees = numTrees+1
        end
    end

    local ratioTreeToTiles = numTrees/numTiles


    if ratioTreeToTiles < 0.5 then
        math.randomseed(self.t)
        local x = math.random(self.player.x- VIRTUAL_WIDTH,self.player.x+ VIRTUAL_WIDTH)
        local y = math.random(self.player.y- VIRTUAL_HEIGHT,self.player.y+ VIRTUAL_HEIGHT)

        local treeTooClose = false
        for i,entity in pairs(self.entities) do
            if entity:distanceTo(x,y) < TILE_SIZE*5 and entity.type == 'tree' then
                treeTooClose = true
            end
        end
        if not treeTooClose then
            local entity
            if math.random(1,6)==1 then
                if math.random(1,2)==1 then
                    entity = Predator {
                        x = x,
                        y = y,
                        biome = self:tileToBiome(self:getTileFrame(x,y)),
                        stats = {
                            armor = math.random(-0.3,0.4) + self.player.stats.armor,
                            speed = math.random(-0.2,0.5) + self.player.stats.speed,
                            damage = math.random(-0.2,0.5) + self.player.stats.damage,
                            maxHp = math.random(-10,20) + self.player.stats.maxHp,
                        }
                    }
                else
                    entity = Prey {
                        x = x,
                        y = y,
                        biome = self:tileToBiome(self:getTileFrame(x,y)),
                        stats = {
                            armor = math.random(-0.3,0.4) + self.player.stats.armor,
                            speed = math.max(self.player.stats.speed - math.random(0.2,1),0.1),
                            damage = math.random(-0.2,0.5) + self.player.stats.damage,
                            maxHp = math.random(-10,20) + self.player.stats.maxHp,
                        }
                    }
                end
            else
                entity = Tree {
                    x = x,
                    y = y,
                    biome = self:tileToBiome(self:getTileFrame(x,y))
                }
            end
            table.insert(self.entities, entity)
        end
    end
end

function World:update(dt)
    self:despawn()
    self.t = self.t + dt
    self.player:applyTerrain(tileToBiome[self:getTileFrame(self.player.x,self.player.y)],self.darkness)
  
    if true then
        for i,n in ipairs(self.iCounter) do
            print(tostring(i)..':'..tostring(self.iCounter[i]) .. ',' .. tostring(self.jCounter[i]))
        end
        print('-----------------------')
    end
    self.spawnTimer = self.spawnTimer-dt
    if self.spawnTimer <= 0 or love.keyboard.isDown('z') or (self.player.walking and not self.player.attacking) then--debug tool
        self:sprinkleMobs()
        self.spawnTimer = math.random(0.5,2.5)
    end
    self.player.stop = false
    for i,entitya in pairs(self.entities) do
        local fx,fy = entitya:getForce(self.player, true)
        if entitya:distanceTo(self.player.x,self.player.y)<20 then
            fx,fy = 0,0
        end
        for j,entityb in pairs(self.entities) do
            local d = entitya:distanceTo(entityb.x,entityb.y)
            if i ~= j and entityb.collidable and d<300 then
                local fijx,fijy = entitya:getForce(entityb, false)
                fx = fx + fijx
                fy = fy + fijy
            end
        end
        entitya:applyForce(self.player,fx,fy,dt)
    end
    self.player.hidden = false
    for i,entity in pairs(self.entities) do
        entity:update(dt, self.player)
        if entity.type == 'tree' then
            entity:hide(self.player)
        end
        if entity:collided(self.player) and entity.collidable then
            self.player:moveBackward(self.player.stats.speed)
        end
        if entity.type == 'predator' or entity.type == 'prey' then
            if entity.stats.hp<1 then
                table.remove(self.entities, i)
                self.player.stats.food = math.min(self.player.stats.food + 30,100)
                self.player.xp = self.player.xp + 5
                if entity.type == 'predator' then
                    self.player.xp = self.player.xp + 35
                end
            end
        end
    end
    if love.keyboard.isDown('r') then
        self.t = self.t+dt*250
    end
end

function World:render(px,py)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setLineStyle( 'rough' )
    local startX,startY = math.floor(px/TILE_SIZE)*TILE_SIZE, math.floor(py/TILE_SIZE)*TILE_SIZE
    for x=startX-VIRTUAL_WIDTH-TILE_SIZE, startX+VIRTUAL_WIDTH+TILE_SIZE,TILE_SIZE do
        for y=startY-VIRTUAL_HEIGHT-TILE_SIZE, startY+VIRTUAL_HEIGHT+TILE_SIZE,TILE_SIZE do
            love.graphics.draw(gTextures['biomes'], gFrames['biomes'][math.max(0,math.min(20,self:getTileFrame(x,y)))], x, y)
        end
    end
    for i,entity in pairs(self.entities) do
        entity:render()
    end
    love.graphics.setColor(255, 255, 255, 255)
    self.player:renderSelf()
    --day night cycle
    self.darkness = math.max(math.min(120*math.sin(self.t/30-9)+50,2*200/3),0)--oscilate between 200 opacity(night) and 0(day), with transitions
    if round(self.darkness) == 10 then
        love.audio.stop(gSounds['music'])
        gSounds['night']:play()
    end
    if self.darkness == 0 then
        love.audio.stop(gSounds['night'])
        gSounds['music']:play()
    end
    love.graphics.setColor(10, 10, 15, self.darkness/2)
    love.graphics.rectangle('fill', self.player.x -VIRTUAL_WIDTH/2, self.player.y-VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(255, 255, 255, 255)
    self.player:renderStats()
    love.graphics.setColor(10, 10, 15, self.darkness)
    love.graphics.rectangle('fill', self.player.x -VIRTUAL_WIDTH/2, self.player.y-VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.draw(gTextures['vignette'],self.player.x - VIRTUAL_WIDTH/2,self.player.y  - VIRTUAL_HEIGHT/2,0,1,1)
end