local function collisionFilter(ghost, other)
  if ghost.dead and other.tag == "pacman" then
    return nil
  end
end

Ghost = Object:extend()

function Ghost:new(x, y, radius, speed, world)
  self.x = x
  self.y = y
  self.radius = radius

  self.world = world
  self.tag = "ghost"

  self.speed = speed
  self.direction = -1

  self.vulnerable = false
  self.vulnerable_time = 3

  self.flash = false
  self.flash_frequency = 15

  self.dead = false

  self.color = { 255, 0, 0 }
  self.flash_color = { 255, 255, 255 }
  self.vulnerable_color = { 0, 0, 255 }
  self.dead_color = { 200, 200, 200, 50 }

  self.timer = Timer()
  self.creation_time = love.timer.getTime()
end

function Ghost:update(dt, pacmanX)
  local now = love.timer.getTime()
  self.vulnerable = self.vulnerable_until and now < self.vulnerable_until
  self.flash = self.vulnerable_until and self.vulnerable_until - now <= 0.5 and self.vulnerable_until - now > 0

  local effective_speed = self.speed
  if self.dead then
    effective_speed = self.speed * 1.2
    if math.abs(self.x - self.go_to_point) < self.radius then
      self.world:update(self, self.go_to_point, self.y)
      self.x = self.go_to_point
      self.dead = false
    else
      self.direction = self.x < self.go_to_point and 1 or -1
      local actualX, _ = self.world:move(self, self.x + (self.direction * effective_speed), self.y, collisionFilter)
      self.x = actualX
    end
  else
    if not self.vulnerable then
      effective_speed = self.speed * 1.1
      self.direction = (self.x < pacmanX) and math.abs(self.direction) or -math.abs(self.direction)
    else
      effective_speed = self.speed * 0.7
      self.direction = (self.x < pacmanX) and -math.abs(self.direction) or math.abs(self.direction)
    end

    if (self.x + self.direction) > (WindowWidth - self.radius) then
      self.world:update(self, WindowWidth - self.radius, self.y)
      self.x = WindowWidth - self.radius
    elseif (self.x + self.direction) < self.radius then
      self.world:update(self, self.radius, self.y)
      self.x = self.radius
    else
      local actualX, _ = self.world:move(self, self.x + (self.direction * effective_speed), self.y)
      self.x = actualX
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

function Ghost:makeVulnerable(multiplier)
  local base_time = 2.25
  local decay_factor = 0.10
  local min_time = 1
  local dynamic_time = math.max(base_time - decay_factor * multiplier, min_time)

  local now = love.timer.getTime()
  if self.vulnerable_until and self.vulnerable_until > now then
    self.vulnerable_until = self.vulnerable_until + self.vulnerable_time
  else
    self.vulnerable_until = now + dynamic_time
  end
end

function Ghost:makeDead(collision_point)
  self.dead = true
  self.vulnerable_until = nil

  self.go_to_point = collision_point > WindowWidth / 2 and self.radius or WindowWidth - self.radius
end
