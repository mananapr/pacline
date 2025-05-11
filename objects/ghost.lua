Ghost = Object:extend()

function Ghost:new(x, y, radius)
	self.x = x
	self.y = y
	self.radius = radius
	self.color = { 255, 0, 0 }
	self.vulnerable_color = { 0, 0, 255 }
	self.vulnerable = false
	self.direction = -1
	self.creation_time = love.timer.getTime()
end

function Ghost:update(dt, pacmanX)
	self.x = self.x + self.direction
	if self.x < pacmanX then
		self.direction = 1
	elseif self.x > pacmanX then
		self.direction = -1
	end
end

function Ghost:draw()
	if self.vulnerable then
		love.graphics.setColor(love.math.colorFromBytes(unpack(self.vulnerable_color)))
	else
		love.graphics.setColor(love.math.colorFromBytes(unpack(self.color)))
	end
	love.graphics.circle("fill", self.x, self.y, self.radius)
end
