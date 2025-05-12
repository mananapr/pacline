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

	self.dead = false

	self.color = { 255, 0, 0 }
	self.flash_color = { 255, 255, 255 }
	self.vulnerable_color = { 0, 0, 255 }
	self.dead_color = { 255, 0, 0, 100 }

	self.timer = Timer()
	self.creation_time = love.timer.getTime()
end

function Ghost:update(dt, pacmanX)
	local now = love.timer.getTime()
	self.vulnerable = self.vulnerable_until and now < self.vulnerable_until
	self.flash = self.vulnerable_until and self.vulnerable_until - now <= 1 and self.vulnerable_until - now > 0

	if self.dead then
		if math.abs(self.x - self.go_to_point) < 1 then
			self.x = self.go_to_point
			self.dead = false
		else
			self.direction = self.x < self.go_to_point and 1 or -1
			self.x = self.x + (self.direction * self.speed)
		end
	else
		if not self.vulnerable then
			self.direction = (self.x < pacmanX) and math.abs(self.direction) or -math.abs(self.direction)
		else
			self.direction = (self.x < pacmanX) and -math.abs(self.direction) or math.abs(self.direction)
		end

		if (self.x + self.direction) > (WindowWidth - self.radius) then
			self.x = WindowWidth - self.radius
		elseif (self.x + self.direction) < self.radius then
			self.x = self.radius
		else
			self.x = self.x + (self.direction * self.speed)
		end
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
	elseif self.dead then
		love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.dead_color)))
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

function Ghost:makeDead(collision_point)
	self.dead = true
	self.vulnerable_until = nil

	self.go_to_point = collision_point > WindowWidth / 2 and self.radius or WindowWidth - self.radius
end
