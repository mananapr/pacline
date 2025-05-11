Ghost = Object:extend()

function Ghost:new(x, y, radius)
	self.x = x
	self.y = y
	self.radius = radius
	self.color = { 255, 0, 0 }
	self.vulnerable_color = { 0, 0, 255 }
	self.vulnerable = false
	self.direction = -2
	self.creation_time = love.timer.getTime()
end

function Ghost:update(dt, pacmanX)
	self.x = self.x + self.direction
	if self.x < pacmanX then
		self.direction = math.abs(self.direction)
	elseif self.x > pacmanX then
		self.direction = -math.abs(self.direction)
	end
end

function Ghost:draw()
	if self.vulnerable then
		love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.vulnerable_color)))
	else
		love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.color)))
	end
	love.graphics.circle("fill", self.x, self.y, self.radius)
end
