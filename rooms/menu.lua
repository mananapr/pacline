MenuRoom = Object:extend()

function MenuRoom:new()
	self.quads = {}
	self.font = love.graphics.newFont(24)
	self.font_color = { 255, 255, 255 }

	self.keys = love.graphics.newImage("assets/keys.png")
	self.quads["return"] = love.graphics.newQuad(212, 48, 24, 16, self.keys:getDimensions())

	self.creation_time = love.timer.getTime()
end

function MenuRoom:update(dt) end

function MenuRoom:draw()
	love.graphics.setFont(self.font)
	love.graphics.setColor(love.math.colorFromBytes(table.unpack(self.font_color)))

	local txt = "pacline"
	local txt_width = self.font:getWidth(txt)
	local txt_height = self.font:getHeight()
	love.graphics.print(txt, (WindowWidth - txt_width) / 2, ((WindowHeight - txt_height) / 2) - 50)

	local _, _, quad_width, quad_height = self.quads["return"]:getViewport()
	love.graphics.draw(
		self.keys,
		self.quads["return"],
		(WindowWidth - 1.5 * quad_width) / 2,
		((WindowHeight - 1.5 * quad_height) / 2) + 50,
		0,
		1.5,
		1.5
	)
end

function MenuRoom:startGame()
	GotoRoom("GameRoom")
end
