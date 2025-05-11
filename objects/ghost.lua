Ghost = Object:extend()

function Ghost:new(x, y, radius, speed)
	self.x = x
	self.y = y
	self.radius = radius
	self.speed = speed + 0.5
	self.direction = -1
	self.vulnerable = false
	self.color = { 255, 0, 0 }
	self.vulnerable_color = { 0, 0, 255 }

	self.timer = Timer()
	self.creation_time = love.timer.getTime()
end

function Ghost:update(dt, pacmanX)
	if not self.vulnerable then
		if self.x < pacmanX then
			self.direction = math.abs(self.direction)
		elseif self.x > pacmanX then
			self.direction = -math.abs(self.direction)
		end
	else
		if self.x < pacmanX then
			self.direction = -math.abs(self.direction)
		elseif self.x > pacmanX then
			self.direction = math.abs(self.direction)
		end
	end

	if (self.x + self.direction) > (WindowWidth - self.radius) then
		self.x = WindowWidth - self.radius
	elseif (self.x + self.direction) < self.radius then
		self.x = self.radius
	else
		self.x = self.x + (self.direction * self.speed)
	end

	self.timer:update(dt)
end

function Ghost:draw()
	if self.vulnerable then
		love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.vulnerable_color)))
	else
		love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.color)))
	end
	love.graphics.circle("fill", self.x, self.y, self.radius)
end

function Ghost:makeVulnerable()
	self.vulnerable = true
	local original_speed = self.speed
	self.speed = original_speed - 0.6
	self.timer:after(3, function()
		self.vulnerable = false
		self.speed = original_speed
	end)
end
