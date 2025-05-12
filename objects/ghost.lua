Ghost = Object:extend()

function Ghost:new(x, y, radius, speed)
	self.x = x
	self.y = y
	self.radius = radius

	self.speed = speed + 0.5
	self.direction = -1
	self.vulnerable = false
	self.vulnerable_time = 3
	self.flash = false
	self.flash_frequency = 15

	self.color = { 255, 0, 0 }
	self.flash_color = { 255, 255, 255 }
	self.vulnerable_color = { 0, 0, 255 }

	self.timer = Timer()
	self.creation_time = love.timer.getTime()
end

function Ghost:update(dt, pacmanX)
	local now = love.timer.getTime()
	self.vulnerable = self.vulnerable_until and now < self.vulnerable_until

	self.flash = self.vulnerable_until and self.vulnerable_until - now <= 1 and self.vulnerable_until - now > 0

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
		if self.flash then
			if math.floor(love.timer.getTime() * self.flash_frequency) % 2 == 0 then
				love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.flash_color)))
			else
				love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.vulnerable_color)))
			end
		else
			love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.vulnerable_color)))
		end
	else
		love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.color)))
	end
	love.graphics.circle("fill", self.x, self.y, self.radius)
end

function Ghost:makeVulnerable()
	local now = love.timer.getTime()
	if self.vulnerable_until and self.vulnerable_until > now then
		self.vulnerable_until = self.vulnerable_until + self.vulnerable_time
	else
		self.vulnerable_until = now + 3
	end
end
