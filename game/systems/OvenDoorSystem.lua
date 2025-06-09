local collision = require("game.util.collision")

local OvenDoorSystem = class {
  query = {
    ovenDoor = { "ovenDoor", "position", "drawable", "open" },
  },

  init = function(self, assets)
    self.assets = assets
  end,

  process = function(self, entities, _, x, y)
    local ovenDoor = entities.ovenDoor[1]

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
      else
        love.audio.play(self.assets:get("assets/oven-close.ogg"))
        ovenDoor.regularDrawable = ovenDoor.closedDrawable
        ovenDoor.highlightDrawable = ovenDoor.closedHighlightDrawable
      end
    end
  end,
}

return OvenDoorSystem
