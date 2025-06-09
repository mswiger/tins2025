local storageUtil = require("game.util.storage")

local function TinBundle(assets, storage)
  local drawable = assets:get("assets/tin.png")
  local x, y = storageUtil.computeStoragePos(storage, drawable)
  storage.storage.filled = true
  return {
    name = "tin",
    tin = true,
    drawable = drawable,
    regularDrawable = drawable,
    highlightDrawable = assets:get("assets/tin-hover.png"),
    highlightable = true,
    layer = 1,
    position = {
      x = x,
      y = y,
    },
    progress = {
      value = 0,
      orientation = "horizontal",
      offsetX = 5,
      offsetY = -15,
      size = 50,
      threshold = 50,
      thresholdMargin = 10,
    },
    grabbable = {
      cursor = love.mouse.newCursor("assets/tin.png"),
      storageType = { "counter", "oven" },
      storageId = storage.storage.id,
    },
    contents = {},
  }
end

return TinBundle
