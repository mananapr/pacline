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
	self.x = self.x + self.direction
end

function Pacman:draw()
	love.graphics.setColor(love.math.colorFromBytes(unpack(self.color)))
	love.graphics.circle("fill", self.x, self.y, self.radius)
end
