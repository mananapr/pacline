Border = Object:extend()

function Border:new(x, y)
	self.x = x
	self.y = y
	self.color = { 0, 0, 255 }
	self.creation_time = love.timer.getTime()
end

function Border:update(dt) end

function Border:draw()
	love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.color)))
	love.graphics.rectangle("fill", self.x, self.y, WindowWidth, 5)
	love.graphics.rectangle("fill", self.x, self.y - 10, WindowWidth, 5)
end
