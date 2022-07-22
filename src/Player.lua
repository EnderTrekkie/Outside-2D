
Player = Class{__includes = Entity}

function Player:init(def)
		self.pulseOpacity = 255
		self.xp = 0
		self.xpGoal = 100
		self.level = 0
        self.x = def.x
        self.y = def.y
        self.width = def.width
        self.height = def.height
        self.hitWidth = def.hitEidth
        self.hitHeight = def.hitHeight
        self.frame = 1
        self.state = ''
        self.direction = 0
        self.walking = false
        self.points = 0
        self.t = 0
        self.hidden = false
        self.attacktime = 0
        self.attackFrame = 0
        self.attacking = false
        self.attackSpeed = 0.2
        self.attackSize = 32
        self.attackX = self.x-900
        self.attackY = self.y-900
        self.Temperature = 0
        self.insulation = 100000
        self.swimming = false
    self.stats = {
    	armor = 0.1,
    	speed = 3,
        baseSpeed = 3,
    	damage = 10,
        maxHp = 100,
		hp = 100,
		maxStamina = 100,
		stamina = 100,
		points = 0,
		food = 100
    }
end

function Player:moveForward()
	local directionChange = 0
	if self.frame > 2 then
		directionChange = PI/4
	end 
	if self.stats.stamina > 0 then
		self.stats.stamina = self.stats.stamina-0.02
		self.x = self.x+math.floor(self.stats.speed*math.sin(self.direction+directionChange)+.5)
		self.y = self.y-math.floor(self.stats.speed*math.cos(self.direction+directionChange)+.5)
	end
end

function Player:applyTerrain(terrainType, dark) 
	if terrainType == 'Ocean' then
		self.swimming = true
		self.stats.speed = self.stats.baseSpeed*2/3
	else
		self.swimming = false
		self.stats.speed = self.stats.baseSpeed
	end
	if (terrainType == "Savanna" or terrainType == "Desert" or terrainType == "Wastes") and dark<10 then
		self.Temperature = self.Temperature+0.2*1/self.insulation
	elseif terrainType == "Glacier" or terrainType == "Mountains" or terrainType == "Snowy Mountains" or terrainType == "Snowy Plains" or terrainType == "Snow_Forest" or terrainType == "Ocean" then
		self.Temperature = self.Temperature-0.2*1/self.insulation
	else
		if self.Temperature>0 then
			self.Temperature = self.Temperature-0.1*1/self.insulation
		end
		if self.Temperature<0 then
			self.Temperature = self.Temperature+0.1*1/self.insulation
		end
	end
end

function Player:moveBackward(intensity)
	local directionChange = 0
	if self.frame > 2 then
		directionChange = PI/4
	end
	self.x = self.x-math.floor(math.sin(self.direction+directionChange)+intensity)
	self.y = self.y+math.floor(math.cos(self.direction+directionChange)+intensity)
end

function Player:update(dt)
	if self.xp >= self.xpGoal then
		self.xp = self.xp - self.xpGoal
		self.xpGoal = self.xpGoal * 1.1
		self.level = self.level + 1
		self.stats.points = self.stats.points + 1
	end
	self.stats.hp = self.stats.hp - math.abs(self.Temperature)
	if self.stats.hp<self.stats.maxHp or self.stats.stamina<self.stats.maxStamina then
		if self.stats.hp<self.stats.maxHp then
			self.stats.hp = self.stats.hp + 0.02
			if self.stats.hp < self.stats.maxHp/2 then
				self.stats.hp = self.stats.hp + 0.02
			end
		end
		if self.stats.stamina<self.stats.maxStamina then
			self.stats.stamina = self.stats.stamina + 0.01
		end
		self.stats.food = self.stats.food-0.01
	end
	self.t = self.t + dt
	self.walking = false
	self.frame = 1
	if love.keyboard.isDown('r') then
		self.stats.food = self.stats.food-1
		self.stats.hp = math.min(self.stats.hp+1,self.stats.maxHp)
		self.stats.stamina = math.min(self.stats.stamina+1,self.stats.maxStamina)
	end
	if self.stats.food<0 then
		self.stats.hp = self.stats.hp-0.05
	end
	local goLeft = love.keyboard.isDown('a')
	local goUp = love.keyboard.isDown('w')
	local goRight = love.keyboard.isDown('d')
	local goDown = love.keyboard.isDown('s')
	if goDown then
		self.direction = PI
	end
	if goUp then
		self.direction = 0
	end
	if goLeft then
		self.direction = -PI/2
		if goUp then
			self.frame = 3
		end
		if goDown then
			self.frame = 3
			self.direction = PI
		end
	end
	if goRight then
		self.direction = PI/2
		if goUp then
			self.frame = 3
			self.direction = 0
		end
		if goDown then
			self.frame = 3
		end
	end
	if goDown or goUp or goRight or goLeft then
		self.walking = true
		self:moveForward()
	end
	if self.attacking then
		self.attackFrame = self.attackFrame + self.attackSpeed
		if self.attackFrame >= 4 then
			self.attacking = false
			self.attackFrame = 0
		end
	end
	self.attackX,self.attackY = self.x-900,self.y-900--make player's attack hitbox out of sight, out of mind when not attacking
	if math.floor(self.attackFrame) == 2 then
	self.attackX,self.attackY = (self.x+math.sin(self.direction)*16)-self.attackSize/2, (self.y-math.cos(self.direction)*16)-self.attackSize/2
	end
	if love.keyboard.isDown('space')  and not self.attacking then
		self.attacking = true
		self.attackFrame = 0
		gSounds['swipe']:play()
	end
end

function Player:collides(target)
end

function Player:renderSelf()
	local frame = self.frame
	if self.walking then
		if self.frame < 3 then
			if self.t*1.1 - math.floor(self.t*1.1) < 0.5 then
				frame = 2
			else
				frame = 1
			end
		else
			if self.t - math.floor(self.t) < 0.5 then
				frame = 4
			else
				frame = 3
			end
		end
	end
	if self.hidden then
	love.graphics.setColor(255,255,255, 100)
	end
	if self.swimming then
		love.graphics.draw(gTextures['player'], gFrames['player'][frame + 16], self.x, self.y,self.direction,1,1,self.width,self.height)
    	love.graphics.draw(gTextures['player'], gFrames['player'][frame+24],
    					self.x-round(math.sin(self.direction+(self.frame-1)/2*PI/4)*16),
    					self.y+round(math.cos(self.direction+(self.frame-1)/2*PI/4)*16),
    					self.direction,1,1,self.width,self.height)--waves
	else
    	love.graphics.draw(gTextures['player'], gFrames['player'][frame], self.x, self.y,self.direction,1,1,self.width,self.height)
	end
    if self.attackFrame > 0 then
    	love.graphics.draw(gTextures['player'], gFrames['player'][math.floor(self.attackFrame)+8],
    					self.x+math.sin(self.direction)*16,
    					self.y-math.cos(self.direction)*16,
    					self.direction,1,1,self.width,self.height)
		--love.graphics.setColor(255, 255, 255, 255)
		--love.graphics.rectangle('line', 
    	--				self.attackX,
    	--				self.attackY,
    	--				self.attackSize,
    	--				self.attackSize)
	end
end

function Player:renderStats()
	if self.stats.hp>self.stats.maxHp/5 then
		self.pulseOpacity = self.pulseOpacity + 3
	end
	self.pulseOpacity = self.pulseOpacity - 5
	love.graphics.setColor(255, 100, 0, self.pulseOpacity)
	if self.pulseOpacity<1 then
		if self.stats.hp<self.stats.maxHp/5 then
			self.pulseOpacity = 255
		elseif self.stats.hp<self.stats.maxHp/3 then
			self.pulseOpacity = 150
		end
	end
	if self.stats.hp<self.stats.maxHp/3 then
		love.graphics.draw(gTextures['vignette'],self.x - VIRTUAL_WIDTH/2,self.y  - VIRTUAL_HEIGHT/2,0,1,1)
	end
	--  HP
	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.rectangle('fill',self.x - VIRTUAL_WIDTH/2, self.y  - VIRTUAL_HEIGHT/2, self.stats.maxHp, 8)
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.rectangle('fill',self.x - VIRTUAL_WIDTH/2, self.y  - VIRTUAL_HEIGHT/2, self.stats.hp, 8)
	love.graphics.setColor(200, 0, 0, 255)
	love.graphics.setFont(gFonts['gothic-small'])
	love.graphics.printf(tostring(round(self.stats.hp)), self.x - VIRTUAL_WIDTH/2, self.y  - VIRTUAL_HEIGHT/2, 1000, 'left')
	--  Stamina
	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.rectangle('fill',self.x - VIRTUAL_WIDTH/2, self.y  - VIRTUAL_HEIGHT/2 + 10, self.stats.maxStamina, 8)
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.rectangle('fill',self.x - VIRTUAL_WIDTH/2, self.y  - VIRTUAL_HEIGHT/2 + 10, self.stats.stamina, 8)
	love.graphics.setColor(0, 200, 0, 255)
	love.graphics.setFont(gFonts['gothic-small'])
	love.graphics.printf(tostring(round(self.stats.stamina)), self.x - VIRTUAL_WIDTH/2, self.y  - VIRTUAL_HEIGHT/2 + 10, 1000, 'left')
	--  Hunger
	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.rectangle('fill',self.x - VIRTUAL_WIDTH/2, self.y  - VIRTUAL_HEIGHT/2 + 20, 100, 8)
	love.graphics.setColor(225, 80, 10, 255)
	love.graphics.rectangle('fill',self.x - VIRTUAL_WIDTH/2, self.y  - VIRTUAL_HEIGHT/2 + 20, self.stats.food, 8)
	love.graphics.setColor(180, 80, 10, 255)
	love.graphics.setFont(gFonts['gothic-small'])
	love.graphics.printf(tostring(round(self.stats.food)), self.x - VIRTUAL_WIDTH/2, self.y  - VIRTUAL_HEIGHT/2 + 20, 1000, 'left')
	--  Armor
	love.graphics.setColor(90, 150, 230, 255)
	love.graphics.rectangle('fill',self.x + VIRTUAL_WIDTH/2, self.y  - VIRTUAL_HEIGHT/2, -self.stats.armor*10, 8)
	love.graphics.setColor(60, 110, 200, 255)
	love.graphics.setFont(gFonts['gothic-small'])
	love.graphics.printf(self.stats.armor, self.x + VIRTUAL_WIDTH/2 - 12, self.y  - VIRTUAL_HEIGHT/2, 1000, 'left')
	-- Temperature
	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.rectangle('fill',self.x - VIRTUAL_WIDTH/2+3, self.y  - VIRTUAL_HEIGHT/2 + 70, 8, 60)
	love.graphics.setColor(40, 140, 40, 255)
	love.graphics.rectangle('fill',self.x - VIRTUAL_WIDTH/2+3, self.y  - VIRTUAL_HEIGHT/2 + 99, 8, 2)
	if self.Temperature<0 then
		love.graphics.setColor(100, 100, 200, 255)
	end
	if self.Temperature>0 then
		love.graphics.setColor(200, 100, 50, 255)
	end
	love.graphics.rectangle('fill',self.x - VIRTUAL_WIDTH/2+3, self.y  - VIRTUAL_HEIGHT/2 + 100, 8, -self.Temperature*1000)

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(gTextures['icons'], gFrames['icon'][7],self.x - VIRTUAL_WIDTH/2,self.y  - VIRTUAL_HEIGHT/2 + 60)--flame
	love.graphics.draw(gTextures['icons'], gFrames['icon'][19],self.x - VIRTUAL_WIDTH/2,self.y  - VIRTUAL_HEIGHT/2 + 120)--frost

	--  XP
	love.graphics.setColor(60, 90, 70, 255)
	love.graphics.rectangle('fill',self.x - VIRTUAL_WIDTH/2 + 1, self.y  + VIRTUAL_HEIGHT/2 - 5, VIRTUAL_WIDTH-2, 4)
	love.graphics.setColor(100, 255, 0, 255)
	love.graphics.rectangle('fill',self.x - VIRTUAL_WIDTH/2 + 1, self.y  + VIRTUAL_HEIGHT/2 - 5, self.xp/self.xpGoal*(VIRTUAL_WIDTH-2), 4)
	love.graphics.setFont(gFonts['medium'])
	love.graphics.printf(tostring(self.level), self.x,self.y+93, 100, 'left')
	if self.stats.hp<=0 then
		love.graphics.setColor(255, 0, 0, 255)
    	gSounds['death']:play()
		gStateMachine:change('game-over')
	end
end