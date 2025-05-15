GameRoom = Object:extend()

function GameRoom:new()
	self.score = 0
	self.multiplier = 0

	self:initMap()

	self.font = love.graphics.newFont(24)
	self.point_color = { 255, 251, 0 }
	self.power_color = { 255, 255, 255 }
	self.font_color = { 255, 255, 255 }

	self.speed = math.floor(self.tilesize / 10)
	self.pacman = Pacman(self:getTileX(8), (WindowHeight / 2) + self.tilesize / 8, self.tilesize / 3, self.speed)
	self.ghost = Ghost(self:getTileX(16), (WindowHeight / 2) + self.tilesize / 8, self.tilesize / 3, self.speed)
	self.border_top = Border(0, (WindowHeight / 2) - self.tilesize / 2)
	self.border_bot = Border(0, (WindowHeight / 2) + self.tilesize / 2 + 15)

	self.game_over = false
	self.creation_time = love.timer.getTime()
end

function GameRoom:update(dt)
	if self.game_over then
		return
	end

	local new_speed = self.speed * (1 + math.log(self.multiplier + 1) * 0.1)
	new_speed = math.min(new_speed, self.tilesize / 3)
	self.pacman.speed = new_speed
	self.ghost.speed = new_speed

	self:checkCollision()
	self:checkPoints()

	self.pacman:update(dt)
	self.ghost:update(dt, self.pacman.x)
end

function GameRoom:draw()
	if self.game_over then
		love.graphics.setFont(self.font)
		love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.font_color)))
		local txt = "You lost! Press r to try again."
		local txt_width = self.font:getWidth(txt)
		local txt_height = self.font:getHeight()
		love.graphics.print(txt, (WindowWidth - txt_width) / 2, ((WindowHeight - txt_height) / 2) + 150)
	end

	for i, tile in ipairs(self.tilemap) do
		local x = self:getTileX(i)
		local y = WindowHeight / 2
		local point_size = self.tilesize / 4

		if tile == 1 then
			love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.point_color)))
			love.graphics.rectangle("fill", x + ((self.tilesize - point_size) / 2), y, point_size, point_size)
		elseif tile == 2 then
			love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.power_color)))
			love.graphics.rectangle("fill", x + ((self.tilesize - point_size) / 2), y, point_size, point_size)
		end
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
end

function GameRoom:getTileX(idx)
	return (idx - 1) * self.tilesize
end

function GameRoom:checkCollision()
	if math.abs(self.pacman.x - self.ghost.x) <= 2 * (self.tilesize / 3) then
		if not self.ghost.vulnerable and not self.ghost.dead then
			self.game_over = true
		elseif not self.ghost.dead then
			local collision_point = self.ghost.x
			self.ghost:makeDead(collision_point)
			self.multiplier = self.multiplier + 1
		end
	end
end

function GameRoom:checkPoints()
	for i, tile in ipairs(self.tilemap) do
		local tile_x = self:getTileX(i)
		local tile_y = WindowHeight / 2
		local tile_center_x = tile_x + self.tilesize / 2
		local tile_center_y = tile_y

		local dx = math.abs(self.pacman.x - tile_center_x)
		local dy = math.abs(self.pacman.y - tile_center_y)

		local hit_radius = self.tilesize / 3

		if dx < hit_radius and dy < hit_radius then
			if tile ~= 0 then
				self.tilemap[i] = 0
				self.remaining_points = self.remaining_points - 1
				self.score = self.score + self.multiplier
				if tile == 2 and not self.ghost.dead then
					self.ghost:makeVulnerable(self.multiplier)
				end
				if self.remaining_points == 0 then
					self:initMap()
				end
			end
		end
	end
end

function GameRoom:toggleDirection()
	self.pacman:toggleDirection()
end

function GameRoom:restart()
	GotoRoom("GameRoom")
end
