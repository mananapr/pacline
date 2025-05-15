Pacman = Object:extend()

function Pacman:new(x, y, radius, speed)
	self.x = x
	self.y = y
	self.radius = radius
	self.speed = speed
	self.direction = 1
	self.color = { 224, 222, 105 }
	self.creation_time = love.timer.getTime()
end

function Pacman:update(dt)
	self.x = self.x + (self.direction * self.speed)

	if self.x - self.radius > WindowWidth then
		self.x = 0 - self.radius
	elseif self.x + self.radius < 0 then
		self.x = WindowWidth + self.radius
	end
end

function Pacman:draw()
	love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.color)))
	love.graphics.circle("fill", self.x, self.y, self.radius)
end

function Pacman:toggleDirection()
	self.direction = -self.direction
end
