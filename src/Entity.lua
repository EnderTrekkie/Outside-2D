
Entity = Class{}

function Entity:init(def)
end

function Entity:distanceTo(x,y)
	return math.sqrt((self.x-x)^2 + (self.y-y)^2)
end

function Entity:collided(player, extrabuffer)
	if not extrabuffer then
		extrabuffer = 0
	end
	return self.x<player.x+player.width/2+extrabuffer and
		   self.y<player.y+player.height/2+extrabuffer and
		   self.x+16>player.x-player.width/2-extrabuffer and
   		   self.y+16>player.y-player.height/2-extrabuffer
end

function Entity:damage(dmg)
end

function Entity:getForce(other, attractive)
	return 0,0
end

function Entity:applyForce(fx,fy)
	return 0,0
end

function Entity:goInvulnerable(duration)
end

function Entity:changeState(name)
end


function Entity:update(dt, player)
end

function Entity:pushFrom(other)
	
end

function Entity:render()end