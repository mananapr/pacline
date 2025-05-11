GameRoom = Object:extend()

function GameRoom:new()
	self.tilesize = WindowWidth / 16
	self.tilemap = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
	self.valid_power_idx = { 1, 2, 3, 4, 5, 12, 13, 14, 15, 16 }
	self:spawnPower()

	self.point_color = { 255, 251, 0 }
	self.power_color = { 255, 255, 255 }

	self.pacman = Pacman(self:getTileX(8), (WindowHeight / 2) + self.tilesize / 8, self.tilesize / 3)
	self.ghost = Ghost(self:getTileX(16), (WindowHeight / 2) + self.tilesize / 8, self.tilesize / 3)
	self.border_top = Border(0, (WindowHeight / 2) - self.tilesize / 2)
	self.border_bot = Border(0, (WindowHeight / 2) + self.tilesize / 2 + 15)

	self.game_over = false
	self.font = love.graphics.newFont(24)
	self.font_color = { 255, 255, 255 }
	self.creation_time = love.timer.getTime()
end

function GameRoom:update(dt)
	if self.game_over then
		return
	end
	if math.abs(self.pacman.x - self.ghost.x) <= 2 * (self.tilesize / 3) then
		self.game_over = true
	end
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

		if tile == 1 then
			love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.point_color)))
			love.graphics.rectangle("fill", x + self.tilesize / 2, y, self.tilesize / 4, self.tilesize / 4)
		elseif tile == 2 then
			love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.power_color)))
			love.graphics.rectangle("fill", x + self.tilesize / 2, y, self.tilesize / 4, self.tilesize / 4)
		end
	end

	self.border_top:draw()
	self.border_bot:draw()

	self.pacman:draw()
	self.ghost:draw()
end

function GameRoom:spawnPower()
	local idx = self.valid_power_idx[love.math.random(#self.valid_power_idx)]
	self.tilemap[idx] = 2
end

function GameRoom:getTileX(idx)
	return (idx - 1) * self.tilesize
end
