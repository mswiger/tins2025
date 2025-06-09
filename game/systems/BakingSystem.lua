local BakingSystem = class {
  BAKE_RATE = 8,

  query = { "baking", "progress", "contents", },

  process = function(self, entities, _, dt)
    for _, e in ipairs(entities) do
      if e.baking then
        e.progress.value = math.min(100, e.progress.value + self.BAKE_RATE * dt)
      end
    end
  end,
}

return BakingSystem
