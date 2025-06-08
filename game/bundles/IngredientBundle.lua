local storageUtil = require("game.util.storage")

local function IngredientBundle(assets, name, storage)
  local drawable = assets:get("assets/" .. name .. ".png")
  local x, y = storageUtil.computeStoragePos(storage, drawable)
  return {
    name = name,
    drawable = drawable,
    regularDrawable = drawable,
    highlightDrawable = assets:get("assets/" .. name .. "-hover.png"),
    highlightable = true,
    layer = 1,
    position = {
      x = x,
      y = y,
    },
    grabbable = {
      cursor = love.mouse.newCursor("assets/" .. name .. ".png"),
      storageType = "pantry",
      storageId = storage.storage.id,
    },
  }
end

return IngredientBundle
