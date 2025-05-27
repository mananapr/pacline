local function collisionFilter(ghost, other)
  if other.tag == "point" or other.tag == "powerpoint" then
    if DebugMode then
      print("ghost point collision")
    end
    return "cross"
  end

  if other.tag == "pacman" then
    if ghost.dead then
      return "cross"
    elseif ghost.vulnerable then
      return "cross"
    else
      return "cross"
    end
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
  self.dead = false

  self.flash_fps = 15

  self.vulnerable_until = nil
  self.go_to_point = nil

  self.timer = Timer()
  self.creation_time = love.timer.getTime()
end

function Ghost:update(dt, pacmanX)
  local now = love.timer.getTime()
  self.vulnerable = self.vulnerable_until and now < self.vulnerable_until
  self.flash = self.vulnerable_until and (self.vulnerable_until - now <= 0.5) and (self.vulnerable_until - now > 0)

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
      local actualX, _ = self.world:move(self, self.x + (self.direction * effective_speed), self.y, collisionFilter)
      self.x = actualX
    end
  end

  self.timer:update(dt)
end

local function drawCentered(img, x, y)
  local ox, oy = img:getWidth() / 2, img:getHeight() / 2
  love.graphics.draw(img, x, y, 0, 1.5, 1.5, ox, oy)
end

function Ghost:draw()
  local sprite
  local alpha = 1

  if self.dead then
    sprite = Res.sprite.ghost.active
    alpha = 0.45
  elseif self.vulnerable then
    sprite = Res.sprite.ghost.vulnerable
    if self.flash then
      if math.floor(love.timer.getTime() * self.flash_fps) % 2 == 0 then
        love.graphics.setColor(0, 0, 0, 1)
        drawCentered(sprite, self.x, self.y)
        return
      end
    end
  else
    sprite = Res.sprite.ghost.active
  end

  love.graphics.setColor(1, 1, 1, alpha)
  drawCentered(sprite, self.x, self.y)
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
