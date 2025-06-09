local collision = require("game.util.collision")
local storageUtil = require("game.util.storage")

local function getOvenStorage(storageEntities)
  for _, e in ipairs(storageEntities) do
    if e.storage.type == "oven" then return e end
  end
  return nil
end

local OvenDoorSystem = class {
  query = {
    ovenDoor = { "ovenDoor", "position", "drawable", "open" },
    storage = { "storage" },
    grabbables = { "grabbable" },
  },

  init = function(self, assets)
    self.assets = assets
  end,

  process = function(self, entities, _, x, y)
    local ovenDoor = entities.ovenDoor[1]
    local ovenStorage = getOvenStorage(entities.storage)
    local items = entities.grabbables or {}

    if not ovenDoor or not ovenStorage then
      return
    end

    if collision.isPointInBox(
      x,
      y,
      ovenDoor.position.x,
      ovenDoor.position.y,
      ovenDoor.drawable:getWidth(),
      ovenDoor.drawable:getHeight()
    ) then
      ovenDoor.open = not ovenDoor.open

      if ovenDoor.open then
        love.audio.play(self.assets:get("assets/oven-open.ogg"))
        ovenDoor.regularDrawable = ovenDoor.openDrawable
        ovenDoor.highlightDrawable = ovenDoor.openHighlightDrawable
        ovenStorage.available = true

        for _, item in ipairs(items) do
          if storageUtil.validStorage(item.grabbable.storageType, "oven") and item.grabbable.storageId == ovenStorage.storage.id then
            item.highlightable = true
            item.grabbable.locked = false
          end
        end
      else
        love.audio.play(self.assets:get("assets/oven-close.ogg"))
        ovenDoor.regularDrawable = ovenDoor.closedDrawable
        ovenDoor.highlightDrawable = ovenDoor.closedHighlightDrawable
        ovenStorage.available = false
        for _, item in ipairs(items) do
          if storageUtil.validStorage(item.grabbable.storageType, "oven") and item.grabbable.storageId == ovenStorage.storage.id then
            item.highlightable = false
            item.grabbable.locked = true
          end
        end
      end
    end
  end,
}

return OvenDoorSystem
