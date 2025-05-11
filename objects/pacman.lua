Pacman = Object:extend()

function Pacman:new(x, y, radius)
	self.x = x
	self.y = y
	self.radius = radius
	self.color = { 224, 222, 105 }
	self.direction = 1
	self.creation_time = love.timer.getTime()
end

function Pacman:update(dt)
	if Control.toggleDirection then
		self.direction = self.direction == 1 and -1 or 1
	end
	self.x = self.x + self.direction
	if self.x > WindowWidth then
		self.x = 0
	elseif self.x < 0 then
		self.x = WindowWidth
	end
end

function Pacman:draw()
	love.graphics.setColor(love.math.colorFromBytes(unpack(self.color)))
	love.graphics.circle("fill", self.x, self.y, self.radius)
end
