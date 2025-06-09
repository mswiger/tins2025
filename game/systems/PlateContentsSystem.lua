local collision = require("game.util.collision")
local storageUtil = require("game.util.storage")

local SPONGE_HEIGHT = 10

local function getPlateDrawable(assets, plate, highlight)
  local plateAsset = assets:get("assets/plate.png")
  local plateHighlightAsset = assets:get("assets/plate-hover.png")
  local w = plateAsset:getWidth()
  local h = plateAsset:getHeight() + #plate.contents * SPONGE_HEIGHT
  local canvas = love.graphics.newCanvas(w, h)

  local yOffset = h - plateAsset:getHeight()
  love.graphics.setCanvas(canvas)
  if highlight then
    love.graphics.draw(plateHighlightAsset, 0, yOffset)
  else
    love.graphics.draw(plateAsset, 0, yOffset)
  end

  for _, layer in ipairs(plate.contents) do
    yOffset = yOffset - SPONGE_HEIGHT
    love.graphics.draw(assets:get("assets/sponge-" .. layer.bake .. ".png"), 2, yOffset)
  end

  love.graphics.setCanvas()

  return canvas
end

local PlateContentsSystem = class {
  query = {
    plate = { "plate", "contents" },
    hand = { "hand" },
    tin = { "tin", "contents" },
    storage = { "storage" },
  },

  init = function(self, assets)
    self.assets = assets
  end,

  process = function(self, entities, _, x, y)
    local hand = entities.hand[1]
    local plate = entities.plate[1]
    local tin = entities.tin[1]

    if not plate or not hand or not tin or not plate.position or not hand.holding or hand.holding == "plate" then
      return
    end

    if collision.isPointInBox(
      x,
      y,
      plate.position.x,
      plate.position.y,
      plate.drawable:getWidth(),
      plate.drawable:getHeight()
    ) and plate.name == "plate" then
      if hand.holding ~= "tin" or tin.contents.ingredients == nil or tin.contents.bake == nil or #plate.contents == 8 or plate.grabbable.storageId == "the-window" then
        love.audio.play(self.assets:get("assets/error.wav"))
      else
        love.audio.play(self.assets:get("assets/ingredient.ogg"):clone())
        table.insert(plate.contents, tin.contents)
        tin.contents = {}
        tin.progress.value = 0
        plate.regularDrawable = getPlateDrawable(self.assets, plate, false)
        plate.highlightDrawable = getPlateDrawable(self.assets, plate, true)
        plate.grabbable.cursor = love.mouse.newCursor(plate.regularDrawable:newImageData())

        local plateStorage = storageUtil.findStorage(plate.grabbable, entities.storage)
        local sx, sy = storageUtil.computeStoragePos(plateStorage, plate.regularDrawable)
        plate.position.x = sx
        plate.position.y = sy
      end
    end
  end
}

return PlateContentsSystem
