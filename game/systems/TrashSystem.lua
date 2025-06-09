local collision = require("game.util.collision")

local TrashSystem = class {
  query = {
    held = { "grabbable", "held", "contents" },
    trash = { "trash", "position" },
  },

  process = function(_, entities, _, x, y)
    local heldItem = entities.held[1]
    local trash = entities.trash[1]

    if heldItem == nil then
      return
    end

    if collision.isPointInBox(
      x,
      y,
      trash.position.x,
      trash.position.y,
      trash.drawable:getWidth(),
      trash.drawable:getHeight()
    ) then
      heldItem.contents = {}
      if heldItem.progress then
        heldItem.progress.value = 0
      end
    end

  end,
}

return TrashSystem
