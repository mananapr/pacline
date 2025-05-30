GameRoom = Object:extend()

function GameRoom:new()
  self.tilesize = WindowWidth / 16
  self.world = Bump.newWorld(self.tilesize)
  self.map = Map(self.world, self.tilesize, WindowHeight)

  self.score = 0
  self.multiplier = 0
  self.multiplier = self.multiplier + 1

  self.font = Res.font.lg
  self.point_color = { 255, 251, 0 }
  self.power_color = { 255, 255, 255 }
  self.font_color = { 255, 255, 255 }

  self.speed = math.floor(self.tilesize) * 5
  self.pacman =
    Pacman(self.map:getTileX(8), (WindowHeight / 2) + self.tilesize / 8, self.tilesize / 3, self.speed, self.world)
  self.ghost =
    Ghost(self.map:getTileX(16), (WindowHeight / 2) + self.tilesize / 8, self.tilesize / 3, self.speed, self.world)

  self.world:add(self.pacman, self.pacman.x, self.pacman.y, 2 * self.pacman.radius, 2 * self.pacman.radius)
  self.world:add(self.ghost, self.ghost.x, self.ghost.y, 2 * self.ghost.radius, 2 * self.ghost.radius)

  self.border_top = Border(0, (WindowHeight / 2) - self.tilesize / 2)
  self.border_bot = Border(0, (WindowHeight / 2) + self.tilesize)

  self.game_over = false
  self.game_over_time = nil
  self.creation_time = love.timer.getTime()

  Res.sound.bgm:setLooping(true)
  Res.sound.bgm:setVolume(0.5)
  Res.sound.bgm:play()
end

function GameRoom:update(dt)
  if self.game_over then
    Res.sound.bgm:stop()
    if not self.game_over_time then
      self.game_over_time = love.timer.getTime()
    elseif love.timer.getTime() - self.game_over_time >= 2 then
      GotoRoom("MenuRoom")
      return
    end
    return
  end

  local new_speed = self.speed * (1 + math.log(self.multiplier + 1) * 0.1) * dt
  new_speed = math.min(new_speed, self.tilesize / 3)
  self.pacman.speed = new_speed
  self.ghost.speed = new_speed

  self.map:update()

  self.pacman:update(dt, function(point)
    self:eatPoint(point)
  end, function()
    self:onCollision()
  end)
  self.ghost:update(dt, self.pacman.x)
end

function GameRoom:draw()
  if DebugMode then
    BumpDebug(self.world)
  end

  if self.game_over then
    love.graphics.setFont(self.font)
    love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.font_color)))

    local txt = "GAME OVER"
    local txt_width = self.font:getWidth(txt)
    local txt_height = self.font:getHeight()

    love.graphics.print(txt, (WindowWidth - txt_width) / 2, ((WindowHeight - txt_height) / 2) + 120)
  end

  self.map:draw()

  love.graphics.setFont(self.font)
  love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.font_color)))
  love.graphics.print(tostring(self.score), 10, 10)
  love.graphics.print("x" .. self.multiplier, 10, 40)

  self.border_top:draw()
  self.border_bot:draw()

  self.pacman:draw()
  self.ghost:draw()
end

function GameRoom:onCollision()
  if not self.ghost.vulnerable and not self.ghost.dead then
    self.game_over = true
    self.game_over_time = nil
    Res.sound.gameover:play()
  elseif not self.ghost.dead then
    local collision_point = self.ghost.x
    self.ghost:makeDead(collision_point)
    self.multiplier = self.multiplier + 1
    Res.sound.vulnerable:play()
  end
end

function GameRoom:eatPoint(point)
  self.map:consumePoint(point)
  self.score = self.score + self.multiplier

  if point.tag == "powerpoint" then
    Res.sound.powerpoint:play()
  else
    Res.sound.point:play()
  end

  if point.tag == "powerpoint" and not self.ghost.dead then
    self.ghost:makeVulnerable(self.multiplier)
  end

  if self.map:isComplete() then
    self.multiplier = self.multiplier + 1
    self.map:generate(self.pacman.x)
  end
end

function GameRoom:toggleDirection()
  self.pacman:toggleDirection()
end
