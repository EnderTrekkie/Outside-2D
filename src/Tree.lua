
Tree = Class{__includes = Entity}

function Tree:init(def)
	self.x = def.x
	self.y = def.y
	self.width = 16
	self.height = 16
	self.biome = def.biome
	self.type = 'tree'
	self.collidable = self.biome == 'Forest' or self.biome == 'Snow_Forest' or self.biome == 'Savana'
end

function Tree:hide(player)
	if self:collided(player,16) and (self.biome == 'Forest' or self.biome == 'Savana') then
		player.hidden = true
	end
end

function Tree:render()
	love.graphics.setColor(255, 255, 255, 255)
	if self.biome == 'Forest' or self.biome == 'Snow_Forest' or self.biome == 'Savana' then
		--trunk
		love.graphics.setColor(70, 50, 20, 255)
		love.graphics.circle('fill', self.x+8, self.y+8, TILE_SIZE/2, 20)
		love.graphics.setColor(30, 100, 20, 150)
	end
	if self.biome == 'Forest' then
		--canopy
		love.graphics.setColor(30, 100, 20, 150)
		love.graphics.circle('fill', self.x+8, self.y+8, TILE_SIZE*CANOPY_SIZE/2, 20)
	end
	if self.biome == 'Snow_Forest' then
		--canopy
		love.graphics.setColor(150, 150, 150, 150)
		love.graphics.draw(gTextures['tiles'], gFrames['bigTiles'][5], self.x-32+8, self.y-32+8)
	end
	if self.biome == 'Savana' then
	--canopy
	love.graphics.setColor(120, 130, 20, 150)
	love.graphics.circle('fill', self.x+8, self.y+8, TILE_SIZE*CANOPY_SIZE/2, 20)
	end
	if self.biome == 'Desert' then
		love.graphics.draw(gTextures['tiles'], gFrames['tiles'][1], self.x, self.y)
	end
	if self.biome == 'Plains' then
		love.graphics.draw(gTextures['tiles'], gFrames['tiles'][7], self.x, self.y)
	end
	if self.biome == 'Ocean' then
		love.graphics.draw(gTextures['tiles'], gFrames['tiles'][2], self.x, self.y)
	end
	if self.biome == 'Wastes' then
		love.graphics.draw(gTextures['tiles'], gFrames['tiles'][3], self.x, self.y)
	end
end