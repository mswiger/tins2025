local collision = require("game.util.collision")
local storageUtil = require("game.util.storage")

local GrabSystem = class {
  query = {
    hand = { "hand" },
    storage = { "storage" },
    grabbables = { "grabbable", "drawable" },
    held = { "grabbable", "held" },
  },

  process = function(_, entities, commands, x, y)
    local hand = entities.hand[1]
    local heldItem = entities.held[1]

    if hand == nil then
      return
    end

    if hand.holding == nil then
      for _, item in ipairs(entities.grabbables) do
        if not item.grabbable.held and collision.isPointInBox(
          x,
          y,
          item.position.x,
          item.position.y,
          item.drawable:getWidth(),
          item.drawable:getHeight()
        ) then
          for _, itemStorage in ipairs(entities.storage) do
            if itemStorage.storage.id == item.grabbable.storageId and
               itemStorage.storage.type == item.grabbable.storageType
            then
              itemStorage.storage.filled = false
            end
          end

          commands:detachComponents(item, "position")
          commands:attachComponents(item, { held = true })
          item.grabbable.storageId = nil
          hand.holding = item.name
          love.mouse.setCursor(item.grabbable.cursor)
          return
        end
      end
    elseif heldItem ~= nil then
      for _, itemStorage in ipairs(entities.storage) do
        if not itemStorage.storage.filled and collision.isPointInBox(
          x,
          y,
          itemStorage.position.x,
          itemStorage.position.y,
          itemStorage.size.width,
          itemStorage.size.height
        ) and itemStorage.storage.type == heldItem.grabbable.storageType then
          local sx, sy = storageUtil.computeStoragePos(itemStorage, heldItem.drawable)
          itemStorage.storage.filled = true
          hand.holding = nil
          heldItem.grabbable.storageId = itemStorage.storage.id
          commands:attachComponents(heldItem, { position = { x = sx, y = sy } })
          commands:detachComponents(heldItem, "held")
          love.mouse.setCursor()
          return
        end
      end
    end
  end,
}

return GrabSystem
