local function sortByLayer(a, b)
  return a.layer < b.layer
end

local RenderingSystem = class {
  query = { "position", "layer", "drawable" },

  process = function(_, entities)
    table.sort(entities, sortByLayer)

    for _, entity in ipairs(entities) do
      if type(entity.drawable) == 'table' then
        love.graphics.draw(entity.drawable.image, entity.drawable.quad, entity.position.x, entity.position.y)
      else
        love.graphics.draw(entity.drawable, entity.position.x, entity.position.y)
      end
    end
  end,
}

return RenderingSystem
