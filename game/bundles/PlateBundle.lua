local storageUtil = require("game.util.storage")

local function PlateBundle(assets, storage)
  local drawable = assets:get("assets/plate.png")
  local x, y = storageUtil.computeStoragePos(storage, drawable)
  storage.storage.filled = true
  return {
    name = "plate",
    plate = true,
    drawable = drawable,
    regularDrawable = drawable,
    highlightDrawable = assets:get("assets/plate-hover.png"),
    highlightable = true,
    layer = 1,
    position = {
      x = x,
      y = y,
    },
    grabbable = {
      cursor = love.mouse.newCursor("assets/plate.png"),
      storageType = "counter",
      storageId = storage.storage.id,
    },
    contents = {},
  }
end

return PlateBundle
