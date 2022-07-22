Menu = Class{__includes = PlayState}

function Menu:init(def)
	self.x = def.x
	self.y = def.y
	self.playerpoints = 0
	self.mousex = 0
	self.mousey = 0
	self.icon1 = {
		x = self.x+70,
		y = self.y+40
	}
	self.icon2 = {
		x = self.x+ (VIRTUAL_WIDTH/2) + 95,
		y = self.y+40
	}
	self.icon3 = {
		x = self.x+70,
		y = self.y+ (VIRTUAL_HEIGHT/2) + 40
	}
	self.icon4 = {
		x = self.x+ (VIRTUAL_WIDTH/2) + 95,
		y = self.y+ (VIRTUAL_HEIGHT/2) + 40
	}
end

function Menu:buttonClicks(mouse, buttonX, buttonY)
	return buttonX<mouse.x+mouse.width/2 and
		   buttonY<mouse.y+mouse.height/2 and
		   buttonX+16>mouse.x-mouse.width/2 and
   		   buttonY+16>mouse.y-mouse.height/2
end

function Menu:update(dt, playerstats)
	local mouse = {x = 0.3*love.mouse.getX( ) + self.x - 5, y = 0.3*love.mouse.getY( ) + self.y - 5, width = 16, height = 16}
	self.mousex = mouse.x
	self.mousey = mouse.y
	if love.mouse.isDown(1) then
		if self:buttonClicks(mouse, self.icon1.x, self.icon1.y) and playerstats.points>=2 then
			playerstats.armor = playerstats.armor + 0.2
			playerstats.points = playerstats.points - 2
		end
		if self:buttonClicks(mouse, self.icon2.x, self.icon2.y) and playerstats.points>=1 then
			playerstats.maxStamina = playerstats.maxStamina + 10
			playerstats.speed = playerstats.speed + 0.3
			playerstats.points = playerstats.points - 1
		end
		if self:buttonClicks(mouse, self.icon3.x, self.icon3.y) and playerstats.points>=1 then
			playerstats.maxHp = playerstats.maxHp + 10
			playerstats.points = playerstats.points - 1
		end
		if self:buttonClicks(mouse, self.icon4.x, self.icon4.y) and playerstats.points>=1 then
			playerstats.damage = playerstats.damage + 1
			playerstats.points = playerstats.points - 1
		end
	end
	self.playerpoints = playerstats.points
	return playerstats
end

function Menu:render()
	-- background
	love.graphics.setColor(35, 35, 28, 252)
	love.graphics.rectangle('fill', self.x, self.y, VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 10)
	love.graphics.setColor(20, 20, 15, 245)
	love.graphics.setLineWidth(4)
	love.graphics.rectangle('line', self.x, self.y, VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 10)
	-- player's levelup points
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(gFonts['medium'])
	love.graphics.printf(tostring(self.playerpoints), self.x + VIRTUAL_WIDTH/2 - 50,self.y + 16, 100, 'center')
	love.graphics.setColor(255, 255, 255, 255)
	--lines
	love.graphics.setColor(25, 22, 20, 255)
	if self.playerpoints < 2 then
		love.graphics.setColor(50, 22, 20, 255)
	end
	love.graphics.line(self.x+ VIRTUAL_WIDTH/2,self.icon1.y + 8,self.icon1.x,self.icon1.y + 8)
	love.graphics.setColor(25, 22, 20, 255)
	if self.playerpoints < 1 then
		love.graphics.setColor(50, 22, 20, 255)
	end
	love.graphics.line(self.x + VIRTUAL_WIDTH/2,self.y+VIRTUAL_HEIGHT*3/4,self.x + VIRTUAL_WIDTH/2,self.icon1.y + 8)
	love.graphics.line(self.x+ VIRTUAL_WIDTH/2 + 95,self.icon3.y + 8,self.icon3.x,self.icon3.y + 8)
	love.graphics.line(self.x+ VIRTUAL_WIDTH/2, self.icon2.y + 8,self.icon2.x,self.icon2.y + 8)
	love.graphics.line(self.x+ VIRTUAL_WIDTH/2 + 95,self.icon4.y + 8,self.icon4.x,self.icon4.y + 8)
	-- icons
	love.graphics.setColor(255, 255, 255, 255)
	--shield
	love.graphics.draw(gTextures['icons'], gFrames['icon'][1],self.icon1.x,self.icon1.y)
	--boot
	love.graphics.draw(gTextures['icons'], gFrames['icon'][2],self.icon2.x,self.icon2.y)
	--heart
	love.graphics.draw(gTextures['icons'], gFrames['icon'][3],self.icon3.x,self.icon3.y)
	--sword
	love.graphics.draw(gTextures['icons'], gFrames['icon'][4],self.icon4.x,self.icon4.y)
	-- player icon
	love.graphics.draw(gTextures['icons'], gFrames['big_icon'][3],
		self.x+VIRTUAL_WIDTH/2 - 16,
		self.y+VIRTUAL_HEIGHT*3/4,
		0, 1, 1)
	-- locked skill boxes
	love.graphics.setColor(200, 0, 0, 100)
	if self.playerpoints < 2 then
		love.graphics.rectangle('fill', self.icon1.x, self.icon1.y, 16, 16)
	end
	if self.playerpoints < 1 then
	love.graphics.rectangle('fill', self.icon2.x, self.icon2.y, 16, 16)
	end
	if self.playerpoints < 1 then
	love.graphics.rectangle('fill', self.icon3.x, self.icon3.y, 16, 16)
	end
	if self.playerpoints < 1 then
	love.graphics.rectangle('fill', self.icon4.x, self.icon4.y, 16, 16)
	end
	love.graphics.setColor(255, 255, 255, 255)
end