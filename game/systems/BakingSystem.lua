local BakingSystem = class {
  BAKE_RATE = 8,

  query = { "baking", "progress", "contents", },

  process = function(self, entities, _, dt)
    for _, e in ipairs(entities) do
      if e.baking then
        e.progress.value = math.min(100, e.progress.value + self.BAKE_RATE * dt)

        if e.progress.value < 40 then
          e.contents.bake = "underbaked"
        elseif e.progress.value >= 40 and e.progress.value <= 60 then
          e.contents.bake = "baked"
        else
          e.contents.bake = "overbaked"
        end
      end
    end
  end,
}

return BakingSystem
