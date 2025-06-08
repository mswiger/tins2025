local storageUtil = require("game.util.storage")

local function FlourBundle(assets, storage)
  local drawable = assets:get("assets/flour.png")
  local x, y = storageUtil.computeStoragePos(storage, drawable)
  return {
    name = "flour",
    drawable = drawable,
    regularDrawable = drawable,
    highlightDrawable = assets:get("assets/flour-hover.png"),
    highlightable = true,
    layer = 1,
    position = {
      x = x,
      y = y,
    },
    grabbable = {
      cursor = love.mouse.newCursor("assets/flour.png"),
      storageType = "pantry",
      storageId = storage.storage.id,
    },
  }
end

return FlourBundle
