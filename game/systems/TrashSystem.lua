local collision = require("game.util.collision")

local TrashSystem = class {
  query = {
    held = { "grabbable", "held", "contents" },
    trash = { "trash", "position" },
  },

  init = function(self, assets)
    self.assets = assets
  end,

  process = function(self, entities, _, x, y)
    local heldItem = entities.held[1]
    local trash = entities.trash[1]

    if collision.isPointInBox(
      x,
      y,
      trash.position.x,
      trash.position.y,
      trash.drawable:getWidth(),
      trash.drawable:getHeight()
    ) then
      if not heldItem then
        love.audio.play(self.assets:get("assets/error.wav"))
      else
        heldItem.contents = {}
        if heldItem.progress then
          heldItem.progress.value = 0
        end
        love.audio.play(self.assets:get("assets/trash.ogg"))
      end
    end

  end,
}

return TrashSystem
