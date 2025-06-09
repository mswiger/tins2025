local collision = require("game.util.collision")

local function valid(ingredient)
  local validItems = { "flour", "sugar", "eggs", "butter" }
  for _, validItem in ipairs(validItems) do
    if validItem == ingredient then return true end
  end
  return false
end

local BowlContentsSystem = class {
  query = {
    bowls = { "contents", "progress", "position" },
    hand = { "hand" },
  },

  init = function(self, assets)
    self.assets = assets
  end,

  process = function(self, entities, _, x, y)
    local bowls = entities.bowls
    local hand = entities.hand[1]

    if not hand or not hand.holding then
      return
    end

    for _, bowl in ipairs(bowls) do
      if collision.isPointInBox(
        x,
        y,
        bowl.position.x,
        bowl.position.y,
        bowl.drawable:getWidth(),
        bowl.drawable:getHeight()
      ) and bowl.name == "bowl" then
        if not valid(hand.holding) or bowl.progress.value >= 100 then
          love.audio.play(self.assets:get("assets/error.wav"))
        else
          love.audio.play(self.assets:get("assets/ingredient.ogg"):clone())
          table.insert(bowl.contents, hand.holding)
          bowl.progress.value = math.min(100, bowl.progress.value + 10)
        end
      end
    end
  end,
}

return BowlContentsSystem
