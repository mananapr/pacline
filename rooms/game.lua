GameRoom = Object:extend()

function GameRoom:new()
  self.world = Bump.newWorld(WindowWidth / 16)

  self.score = 0
  self.multiplier = 0

  self:initMap()

  self.font = love.graphics.newFont(24)
  self.point_color = { 255, 251, 0 }
  self.power_color = { 255, 255, 255 }
  self.font_color = { 255, 255, 255 }

  self.speed = math.floor(self.tilesize / 10)
  self.pacman =
    Pacman(self:getTileX(8), (WindowHeight / 2) + self.tilesize / 8, self.tilesize / 3, self.speed, self.world)
  self.ghost =
    Ghost(self:getTileX(16), (WindowHeight / 2) + self.tilesize / 8, self.tilesize / 3, self.speed, self.world)

  self.world:add(self.pacman, self.pacman.x, WindowHeight / 2, 2 * self.tilesize / 3, 2 * self.tilesize / 3)
  self.world:add(self.ghost, self.ghost.x, WindowHeight / 2, 2 * self.tilesize / 3, 2 * self.tilesize / 3)

  self.border_top = Border(0, (WindowHeight / 2) - self.tilesize / 2)
  self.border_bot = Border(0, (WindowHeight / 2) + self.tilesize)

  self.game_over = false
  self.game_over_time = nil
  self.creation_time = love.timer.getTime()
end

function GameRoom:update(dt)
  if self.game_over then
    if not self.game_over_time then
      self.game_over_time = love.timer.getTime()
    elseif love.timer.getTime() - self.game_over_time >= 2 then
      GotoRoom("MenuRoom")
      return
    end
    return
  end

  local new_speed = self.speed * (1 + math.log(self.multiplier + 1) * 0.1)
  new_speed = math.min(new_speed, self.tilesize / 3)
  self.pacman.speed = new_speed
  self.ghost.speed = new_speed

  for _, point in ipairs(self.points) do
    point:update(dt)
  end

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

  for _, point in ipairs(self.points) do
    point:draw()
  end

  love.graphics.setFont(self.font)
  love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.font_color)))
  love.graphics.print(tostring(self.score), 10, 10)
  love.graphics.print("x" .. self.multiplier, 10, 40)

  self.border_top:draw()
  self.border_bot:draw()

  self.pacman:draw()
  self.ghost:draw()
end

function GameRoom:initMap()
  self.tilesize = WindowWidth / 16
  self.tilemap = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
  self.valid_power_idx = { 1, 2, 3, 4, 5, 12, 13, 14, 15, 16 }
  self.remaining_points = #self.tilemap
  local idx = self.valid_power_idx[love.math.random(#self.valid_power_idx)]
  self.tilemap[idx] = 2
  self.multiplier = self.multiplier + 1

  self.points = {}
  for i, tile in ipairs(self.tilemap) do
    if tile == 1 then
      local point_size = self.tilesize / 4
      local x = self:getTileX(i) + ((self.tilesize - point_size) / 2)
      local y = ((WindowHeight - point_size) / 2) + 5
      local p = Point(i, x, y, point_size)
      table.insert(self.points, p)
      self.world:add(p, p.x, p.y, point_size, point_size)
    elseif tile == 2 then
      local point_size = self.tilesize / 6
      local x = self:getTileX(i) + ((self.tilesize - point_size) / 2)
      local y = ((WindowHeight - point_size) / 2) + 5
      local p = PowerPoint(i, x, y, point_size)
      table.insert(self.points, p)
      self.world:add(p, p.x, p.y, point_size, point_size)
    end
  end
end

function GameRoom:getTileX(idx)
  return (idx - 1) * self.tilesize
end

function GameRoom:onCollision()
  if not self.ghost.vulnerable and not self.ghost.dead then
    self.game_over = true
    self.game_over_time = nil
  elseif not self.ghost.dead then
    local collision_point = self.ghost.x
    self.ghost:makeDead(collision_point)
    self.multiplier = self.multiplier + 1
  end
end

function GameRoom:eatPoint(point)
  self.world:remove(point)
  point.active = false
  self.tilemap[point.idx] = 0
  self.remaining_points = self.remaining_points - 1
  self.score = self.score + self.multiplier

  if point.tag == "powerpoint" and not self.ghost.dead then
    self.ghost:makeVulnerable(self.multiplier)
  end
  if self.remaining_points == 0 then
    self:initMap()
  end
end

function GameRoom:toggleDirection()
  self.pacman:toggleDirection()
end
