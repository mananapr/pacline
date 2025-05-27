Object = require("libs/classic")
Timer = require("libs/hump/timer")
Bump = require("libs/bump")

table.unpack = table.unpack or unpack

function love.load()
  require("utils")

  local object_files = {}
  RecursiveEnumerate("objects", object_files)
  RequireFiles(object_files)

  local room_files = {}
  RecursiveEnumerate("rooms", room_files)
  RequireFiles(room_files)

  WindowWidth, WindowHeight = love.graphics.getDimensions()

  DebugMode = CheckDebug()

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

---@diagnostic disable-next-line: unused-local
function love.keypressed(key)
  if CurrentRoom then
    if CurrentRoom.startGame then
      CurrentRoom:startGame()
    end
    if CurrentRoom.toggleDirection then
      CurrentRoom:toggleDirection()
    end
  end
end

---@diagnostic disable-next-line: unused-local
function love.mousepressed(x, y, button)
  if CurrentRoom then
    if CurrentRoom.startGame then
      CurrentRoom:startGame()
    end
    if CurrentRoom.toggleDirection then
      CurrentRoom:toggleDirection()
    end
  end
end
