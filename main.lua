Object = require("libs/classic")
Timer = require("libs/hump/timer")

table.unpack = table.unpack or unpack

local function recursiveEnumerate(folder, file_list)
	local items = love.filesystem.getDirectoryItems(folder)
	for _, item in ipairs(items) do
		local file = folder .. "/" .. item
		local file_info = love.filesystem.getInfo(file)
		if file_info.type == "file" then
			table.insert(file_list, file)
		elseif file_info.type == "directory" then
			recursiveEnumerate(file, file_list)
		end
	end
end

local function requireFiles(files)
	for _, file in ipairs(files) do
		local mod = file:sub(1, -5)
		require(mod)
		print("loaded " .. mod)
	end
end

function GotoRoom(room_type, ...)
	CurrentRoom = _G[room_type](...)
end

function love.load()
	local object_files = {}
	recursiveEnumerate("objects", object_files)
	requireFiles(object_files)

	local room_files = {}
	recursiveEnumerate("rooms", room_files)
	requireFiles(room_files)

	WindowWidth, WindowHeight = love.graphics.getDimensions()

	CurrentRoom = nil
	GotoRoom("MenuRoom")
end

function love.update(dt)
	if CurrentRoom then
		CurrentRoom:update(dt)
	end
end

function love.draw()
	if CurrentRoom then
		CurrentRoom:draw()
	end
end

function love.keypressed(key)
	if key == "return" then
		if CurrentRoom and CurrentRoom.startGame then
			CurrentRoom:startGame()
		end
	elseif key == "space" then
		if CurrentRoom and CurrentRoom.toggleDirection then
			CurrentRoom:toggleDirection()
		end
	elseif key == "r" then
		if CurrentRoom and CurrentRoom.restart then
			CurrentRoom:restart()
		end
	end
end
