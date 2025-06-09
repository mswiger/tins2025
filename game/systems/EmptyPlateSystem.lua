local EmptyPlateSystem = class {
  query = {
    hand = { "hand" },
    plate = {"plate" },
    storage = { "storage" },
  },

  init = function(self, assets)
    self.assets = assets
  end,

  process = function(self, entities)
    local plate = entities.plate[1]
    local hand = entities.hand[1]

    if plate == nil then
      return
    end

    if #plate.contents == 0 then
      plate.regularDrawable = self.assets:get("assets/plate.png")
      plate.highlightDrawable = self.assets:get("assets/plate-hover.png")
      plate.grabbable.cursor = love.mouse.newCursor("assets/plate.png")
      plate.drawable = plate.regularDrawable
      if hand.holding == "plate" then
          love.mouse.setCursor(plate.grabbable.cursor)
        end
    end
  end,
}

return EmptyPlateSystem
