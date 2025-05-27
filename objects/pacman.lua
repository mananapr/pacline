local function collisionFilter(_, other)
  if other.tag == "ghost" then
    if not other.dead and not other.vulnerable then
      if DebugMode then
        print("game over collision")
      end
      return "touch"
    elseif not other.dead then
      if DebugMode then
        print("vulnerable collision")
      end
      other:makeDead(other.x)
    end
    return "cross"
  else
    return nil
  end
end

Pacman = Object:extend()

function Pacman:new(x, y, radius, speed, world)
  self.x = x
  self.y = y
  self.radius = radius
  self.tag = "pacman"
  self.world = world
  self.speed = speed
  self.direction = 1
  self.color = { 224, 222, 105 }
  self.creation_time = love.timer.getTime()
end

function Pacman:update(dt)
  local targetX = self.x + (self.direction * self.speed)
  local targetY = self.y
  local actualX, actualY, _ = self.world:move(self, targetX, targetY, collisionFilter)
  self.x, self.y = actualX, actualY

  if self.x - self.radius > WindowWidth then
    self.world:update(self, 0 - self.radius, self.y)
    self.x = 0 - self.radius
  elseif self.x + self.radius < 0 then
    self.world:update(self, WindowWidth + self.radius, self.y)
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
