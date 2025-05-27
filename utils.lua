function RecursiveEnumerate(folder, file_list)
  local items = love.filesystem.getDirectoryItems(folder)
  for _, item in ipairs(items) do
    local file = folder .. "/" .. item
    local file_info = love.filesystem.getInfo(file)
    if file_info.type == "file" then
      table.insert(file_list, file)
    elseif file_info.type == "directory" then
      RecursiveEnumerate(file, file_list)
    end
  end
end

function RequireFiles(files)
  for _, file in ipairs(files) do
    local mod = file:sub(1, -5)
    require(mod)
    print("loaded " .. mod)
  end
end

function GotoRoom(room_type, ...)
  CurrentRoom = _G[room_type](...)
end

function CheckDebug()
  if arg then
    for _, v in ipairs(arg) do
      if v == "-debug" then
        return true
      end
    end
  end
  return false
end

local function getCellRect(world, cx, cy)
  local cellSize = world.cellSize
  local l, t = world:toWorld(cx, cy)
  return l, t, cellSize, cellSize
end

function BumpDebug(world)
  local cellSize = world.cellSize
  local font = love.graphics.getFont()
  local fontHeight = font:getHeight()
  local topOffset = (cellSize - fontHeight) / 2
  for cy, row in pairs(world.rows) do
    for cx, cell in pairs(row) do
      local l, t, w, h = getCellRect(world, cx, cy)
      local intensity = (cell.itemCount * 12 + 16) / 256
      love.graphics.setColor(1, 1, 1, intensity)
      love.graphics.rectangle("fill", l, t, w, h)
      love.graphics.setColor(1, 1, 1, 0.25)
      love.graphics.printf(cell.itemCount, l, t + topOffset, cellSize, "center")
      love.graphics.setColor(1, 1, 1, 0.04)
      love.graphics.rectangle("line", l, t, w, h)
    end
  end
end
