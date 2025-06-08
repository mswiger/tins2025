local collision = require("game.util.collision")

local BowlContentsSystem = class {
  query = {
    bowls = { "bowlContents", "progress" },
    hand = { "hand" },
  },

  process = function(_, entities, _, x, y)
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
      ) and bowl.progress.value < 100 then
        table.insert(bowl.bowlContents, hand.holding)
        bowl.progress.value = math.min(100, bowl.progress.value + 10)
      end
    end
  end,
}

return BowlContentsSystem
