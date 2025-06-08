local collision = require("game.util.collision")

local HighlightSystem = class {
  query = { "drawable", "regularDrawable", "highlightDrawable", "position", "highlightable" },

  init = function(self, camera)
    self.camera = camera
  end,

  process = function(self, entities)
    local mx, my = self.camera:worldCoords(love.mouse.getPosition())

    for _, entity in ipairs(entities) do
      local w = entity.drawable:getWidth()
      local h = entity.drawable:getHeight()

      if entity.highlightable and collision.isPointInBox(mx, my, entity.position.x, entity.position.y, w, h) then
        entity.drawable = entity.highlightDrawable
      else
        entity.drawable = entity.regularDrawable
      end
    end
  end,
}

return HighlightSystem
