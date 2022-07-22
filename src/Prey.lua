
Prey = Class{__includes = Entity}

function Prey:init(def)
	self.x = def.x
	self.y = def.y
	self.width = 16
	self.height = 16
	self.biome = def.biome
	self.type = 'prey'
	self.closeToPlayer = false
	self.collidable = true
	self.attacking = false
	self.attackCooldown = 1
    self.attackSize = 20
    self.attackX = self.x-900
    self.attackY = self.y-900
    self.hidden = false
    self.pathCooldown = 0
    self.pathX = self.x
    self.pathY = self.y
    self.stats = def.stats
    self.stats.hp = self.stats.maxHp
    self.direction = 0
end

function Prey:move(player,dt)
    self.direction = 0
	if self:collided(player,64) then
		self.closeToPlayer = true
	end
	if self.pathX > self.x then
		self.direction = self.direction + PI/2
	end
	if self.pathX < self.x then
		self.direction = self.direction - PI/2
	end
	if self.pathY > self.y then
		self.direction = self.direction + PI/2
	end
	if self.pathY > self.y then
		self.direction = self.direction - PI/2
	end
	if math.abs(self.x-self.pathX)<8 and math.abs(self.y-self.pathY)<8 then--find new spot
		if self.pathCooldown <= 0 then
			local pathRange = 32
    		self.pathX = self.x + math.random(-pathRange,pathRange)
    		self.pathY = self.y + math.random(-pathRange,pathRange)
    		self.pathCooldown = math.random(0,1.3)
    	end
	else--do moveage
		if self.pathCooldown <= 0 then
			local dx = self.pathX-self.x
			local dy = self.pathY-self.y
			local d = math.sqrt(dx^2+dy^2)
			if self.closeToPlayer then
				d = -d
			end
			local walkX = (self.stats.speed/d)*dx
			local walkY = (self.stats.speed/d)*dy
			self.x = self.x + walkX
			self.y = self.y + walkY
		end
	end
	if self.pathCooldown >= 0 then--wait, then walk
    	self.pathCooldown = self.pathCooldown - dt
    end
end

function Prey:getHit(player)
	if self:collided({x = player.attackX, y = player.attackY, width = 32, height = 32}) then
		self.stats.hp = self.stats.hp - math.max(0,player.stats.damage -self.stats.armor)
		if player.stats.damage - self.stats.armor < 1 then
			gSounds['ding']:play()
			love.graphics.setColor(100, 150, 200, 255)
			love.graphics.printf('0',self.x,self.y-16,100,'left')
		else
			gSounds['hit']:play()
			love.graphics.setColor(255, 0, 0, 255)
			love.graphics.printf(tostring(round(player.stats.damage - self.stats.armor)),self.x,self.y-16,100,'left')
		end
		love.graphics.setColor(255, 255, 255, 255)
	end
end

function Prey:update(dt, player)
	self:move(player,dt)
	if player.attacking then
		self:getHit(player)
	end
end

function Prey:render()
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.rectangle('fill', self.x, self.y-4, self.stats.hp/(self.stats.maxHp/16), 4)
	love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['entities'], gFrames['entity'][2], round(self.x), round(self.y),self.direction,1,1,12,12)
	--love.graphics.setColor(255, 255, 255, 255)
	--love.graphics.rectangle('line', self.x, self.y-4, 16, 16)
end