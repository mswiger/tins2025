local collision = require("game.util.collision")

function okay(val, max)
  for i = 1, (max or 3) do
    if val == i then return true end
  end

  return false
end

local TinSystem = class {
  query = {
    bowl = { "grabbable", "held" },
    tin = { "tin", "contents", "position" },
  },

  init = function(self, assets)
    self.assets = assets
  end,

  process = function(self, entities, _, x, y)
    local bowl = entities.bowl[1]
    local tin = entities.tin[1]

    if not tin or not bowl then
      return
    end

    if collision.isPointInBox(
      x,
      y,
      tin.position.x,
      tin.position.y,
      tin.drawable:getWidth(),
      tin.drawable:getHeight()
    ) then
      if not bowl.bowl or #tin.contents > 0 or #bowl.contents == 0 then
        love.audio.play(self.assets:get("assets/error.wav"))
        return
      end

      love.audio.play(self.assets:get("assets/batter.ogg"))

      local counts = {}
      for _, ingredient in ipairs(bowl.contents) do
        if counts[ingredient] == nil then
          counts[ingredient] = 0
        end
        counts[ingredient] = counts[ingredient] + 1
      end

      if counts.sugar == 2 and counts.flour == 2 and counts.butter == 2 and counts.eggs == 1 then
        tin.contents = { ingredients = "perfect" }
      elseif okay(counts.sugar) and okay(counts.flour) and okay(counts.butter) and okay(counts.eggs, 2) then
        tin.contents = { ingredients = "okay" }
      else
        tin.contents = { ingredients = "disaster" }
      end

      tin.progress.value = 1

      bowl.contents = {}
      if bowl.progress then
        bowl.progress.value = 0
      end
    end
  end,
}

return TinSystem
