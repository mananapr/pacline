Point = Object:extend()

function Point:new(x, y, size)
  self.x = x
  self.y = y
  self.size = size
  self.active = true
  self.color = { 255, 251, 0 }
  self.creation_time = love.timer.getTime()
end

function Point:update(dt) end

function Point:draw()
  if self.active then
    love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.color)))
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
  end
end

PowerPoint = Point:extend()

function PowerPoint:new(x, y, size)
  PowerPoint.super.new(self, x, y, size)
  self.color = { 255, 255, 255 }
  self.visible = true
  self.flash_interval = 0.2
  self.last_toggle_time = love.timer.getTime()
end

function PowerPoint:update(dt)
  local current_time = love.timer.getTime()
  if current_time - self.last_toggle_time >= self.flash_interval then
    self.visible = not self.visible
    self.last_toggle_time = current_time
  end
end

function PowerPoint:draw()
  if self.active and self.visible then
    love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.color)))
    love.graphics.rectangle("fill", self.x - self.size, self.y, self.size * 3, self.size)
    love.graphics.rectangle("fill", self.x, self.y - self.size, self.size, self.size * 3)
  end
end
