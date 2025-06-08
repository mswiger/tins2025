local storageUtil = require("game.util.storage")

local function BowlBundle(assets, storage)
  local drawable = assets:get("assets/bowl.png")
  local x, y = storageUtil.computeStoragePos(storage, drawable)
  storage.storage.filled = true
  return {
    name = "bowl",
    drawable = drawable,
    regularDrawable = drawable,
    highlightDrawable = assets:get("assets/bowl-hover.png"),
    highlightable = true,
    layer = 1,
    position = {
      x = x,
      y = y,
    },
    progress = {
      value = 0,
      orientation = "vertical",
      offsetX = 85,
      offsetY = 3,
      size = 50,
    },
    grabbable = {
      cursor = love.mouse.newCursor("assets/bowl.png"),
      storageType = "counter",
      storageId = storage.storage.id,
    },
    bowlContents = {},
  }
end

return BowlBundle
