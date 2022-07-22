
Predator = Class{__includes = Entity}

function Predator:init(def)
	self.x = def.x
	self.y = def.y
	self.width = 16
	self.height = 16
	self.biome = def.biome
	self.type = 'predator'
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

function Predator:tryAttack(player,dt)
	self.attackCooldown = self.attackCooldown + dt
	if self.attackCooldown > 1 then
		self.attackCooldown = 0
		player.stats.hp = player.stats.hp - math.max(0, self.stats.damage - player.stats.armor)
		if player.stats.hp < player.stats.maxHp/3 then
			player.stats.hp = player.stats.hp + math.max(0, self.stats.damage - player.stats.armor)/2
		end
		player.regenCooldown = 0
		if self.stats.damage - player.stats.armor < 1 then
			gSounds['ding']:play()
		else
			gSounds['hit']:play()
		end
	end
end

function Predator:findCorner(targX,targY)
	local assumeSize = 16
	local corner1x = targX-assumeSize
	local corner1y = targY-assumeSize
	local corner1 = math.sqrt(corner1y^2+corner1x^2)

	local corner2x = targX+assumeSize
	local corner2y = targY-assumeSize
	local corner2 = math.sqrt(corner2y^2+corner2x^2)

	local corner3x = targX-assumeSize
	local corner3y = targY+assumeSize
	local corner3 = math.sqrt(corner3y^2+corner3x^2)

	local corner4x = targX+assumeSize
	local corner4y = targY+assumeSize
	local corner4 = math.sqrt(corner4y^2+corner4x^2)

	local cornerpick = math.min(corner1,corner2,corner3,corner4)
	if cornerpick == corner1 then
		return corner1x,corner1y
	end
	if cornerpick == corner2 then
		return corner2x,corner2y
	end
	if cornerpick == corner3 then
		return corner3x,corner3y
	end
	if cornerpick == corner4 then
		return corner4x,corner4y
	end
end

function Predator:move(player,dt)
    self.direction = 0
	if self:collided(player,64) then
		self.pathX,self.pathY = self:findCorner(player.x,player.y)
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
	if self:collided(player,16) then
		self:tryAttack(player,dt)
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
			if self.x == player.x and self.y == player.y then
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

function Predator:getHit(player)
	if self:collided({x = player.attackX+16, y = player.attackY+16, width = 32, height = 32}) then
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

function Predator:update(dt, player)
	self:move(player,dt)
	if player.attacking then
		self:getHit(player)
	end
end

function Predator:render()
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.rectangle('fill', self.x, self.y-16, self.stats.hp/(self.stats.maxHp/16), 4)
	love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['entities'], gFrames['entity'][1], round(self.x), round(self.y),self.direction,1,1,12,12)
	--love.graphics.setColor(255, 255, 255, 255)
	--love.graphics.rectangle('line', self.x-8, self.y-8, 16, 16)
end