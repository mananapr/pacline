local function collisionFilter(_, other)
  if other.tag == "ghost" then
    if not other.dead and not other.vulnerable then
      if DebugMode then
        print("game over collision")
      end
      return "cross"
    elseif not other.dead then
      if DebugMode then
        print("vulnerable collision")
      end
    end
    return "cross"
  end

  if other.tag == "point" or other.tag == "powerpoint" then
    if DebugMode then
      print("pacman point collision")
    end
    return "cross"
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

  self.framesRight = Res.sprite.pacman.right
  self.framesLeft = Res.sprite.pacman.left
  self.framesCurrent = self.framesRight
  self.frame = 1
  self.frameTimer = 0
  self.anim_speed = 0.08

  self.creation_time = love.timer.getTime()
end

function Pacman:update(dt, onEat, onCollision)
  local targetX = self.x + (self.direction * self.speed)
  local targetY = self.y
  local actualX, actualY, cols = self.world:move(self, targetX, targetY, collisionFilter)
  self.x, self.y = actualX, actualY

  for i = 1, #cols do
    local other = cols[i].other
    if (other.tag == "point" or other.tag == "powerpoint") and other.active then
      onEat(other)
    elseif other.tag == "ghost" then
      onCollision()
    end
  end

  if self.x - self.radius > WindowWidth then
    self.world:update(self, 0 - self.radius, self.y)
    self.x = 0 - self.radius
  elseif self.x + self.radius < 0 then
    self.world:update(self, WindowWidth + self.radius, self.y)
    self.x = WindowWidth + self.radius
  end

  self.frameTimer = self.frameTimer + dt
  if self.frameTimer >= self.anim_speed then
    self.frameTimer = self.frameTimer - self.anim_speed
    self.frame = self.frame % #self.framesCurrent + 1
  end
end

function Pacman:draw()
  local sprite = self.framesCurrent[self.frame]
  local ox, oy = sprite:getWidth() / 2, sprite:getHeight() / 2
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(sprite, self.x, self.y, 0, 1.5, 1.5, ox, oy)
end

function Pacman:toggleDirection()
  self.direction = -self.direction
  self.framesCurrent = (self.direction == 1) and self.framesRight or self.framesLeft
end
