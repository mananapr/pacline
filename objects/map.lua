Map = Object:extend()

function Map:new(world, tilesize, screen_height)
  self.world = world
  self.tilesize = tilesize
  self.screen_height = screen_height

  self.valid_power_idx = { 1, 2, 3, 4, 5, 12, 13, 14, 15, 16 }
  self.points = {}
  self.tilemap = {}
  self.remaining_points = 0

  self:generate()
end

function Map:generate()
  self.points = {}
  self.tilemap = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }

  local power_idx = self.valid_power_idx[love.math.random(#self.valid_power_idx)]
  self.tilemap[power_idx] = 2

  self.remaining_points = 0

  for i, tile in ipairs(self.tilemap) do
    local point_size, point_class

    if tile == 1 then
      point_size = self.tilesize / 4
      point_class = Point
    elseif tile == 2 then
      point_size = self.tilesize / 6
      point_class = PowerPoint
    end

    if point_class then
      local x = self:getTileX(i) + ((self.tilesize - point_size) / 2)
      local y = ((self.screen_height - point_size) / 2) + 5
      local point = point_class(i, x, y, point_size)
      table.insert(self.points, point)
      self.world:add(point, x, y, point_size, point_size)
      self.remaining_points = self.remaining_points + 1
    end
  end
end

function Map:getTileX(idx)
  return (idx - 1) * self.tilesize
end

function Map:consumePoint(point)
  self.tilemap[point.idx] = 0
  point.active = false
  self.world:remove(point)
  self.remaining_points = self.remaining_points - 1
end

function Map:isComplete()
  return self.remaining_points <= 0
end

function Map:update(dt)
  for _, point in ipairs(self.points) do
    if point.active then
      point:update(dt)
    end
  end
end

function Map:draw()
  for _, point in ipairs(self.points) do
    if point.active then
      point:draw()
    end
  end
end
