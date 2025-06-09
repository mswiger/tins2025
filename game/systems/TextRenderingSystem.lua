local TextRenderingSystem = class {
  query = { "text", "position" },

  init = function(self, assets)
    self.assets = assets
  end,

  process = function(self, entities)
    for _, entity in ipairs(entities) do
      love.graphics.setFont(self.assets:get("assets/bitstream-vera-mono-bold.ttf", entity.text.size))
      love.graphics.setColor(unpack(entity.text.color))
      love.graphics.print(entity.text.value, entity.position.x, entity.position.y)
    end
  end,
}

return TextRenderingSystem
