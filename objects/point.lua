Point = Object:extend()

function Point:new(idx, x, y, size)
  self.idx = idx
  self.x = x
  self.y = y
  self.size = size
  self.tag = "point"
  self.active = true
  self.color = { 255, 251, 0 }
  self.creation_time = love.timer.getTime()
end

---@diagnostic disable-next-line: unused-local
function Point:update(dt) end

function Point:draw()
  if self.active then
    love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.color)))
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
  end
end

PowerPoint = Point:extend()

function PowerPoint:new(idx, x, y, size)
  PowerPoint.super.new(self, idx, x, y, size)
  self.color = { 255, 255, 255 }
  self.tag = "powerpoint"
  self.visible = true
  self.flash_interval = 0.2
  self.last_toggle_time = love.timer.getTime()
end

---@diagnostic disable-next-line: unused-local
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
