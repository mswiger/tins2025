local function setProgressBarColor(progress)
  if (progress.threshold == nil or progress.value <= progress.threshold) then
    love.graphics.setColor(90/256, 181/256, 82/256)
  else
    love.graphics.setColor(0.92, 0.15, 0.25)
  end
end

local ProgressBarSystem = class {
  DEFAULT_SIZE = 100,
  DEFAULT_THICKNESS = 10,

  query = { "position", "progress" },

  process = function(self, entities)
    for _, entity in ipairs(entities) do
      local size = entity.progress.size or self.DEFAULT_SIZE
      local normalizedProgress = entity.progress.value * (size / 100)
      local normalizedThreshold = entity.progress.threshold and (entity.progress.threshold * (size / 100))
      local x = entity.position.x + (entity.progress.offsetX or 0)
      local y = entity.position.y + (entity.progress.offsetY or 0)

      if entity.progress.orientation ~= "horizontal" and entity.progress.orientation ~= "vertical" then
        error(entity.progress.orientation .. " is not a valid orientation (must be horizontal or vertical)")
      end


      if entity.progress.value > 0 and entity.progress.orientation == "vertical" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", x, y, self.DEFAULT_THICKNESS, size + 2)

        setProgressBarColor(entity.progress)
        love.graphics.rectangle(
          "fill",
          x + 1,
          y + 1 + (size - normalizedProgress),
          self.DEFAULT_THICKNESS - 2,
          normalizedProgress
        )

        if entity.progress.threshold ~= nil then
          local tx = x + 1
          local ty = y + 1 + size - normalizedThreshold
          love.graphics.setColor(176/256, 167/256, 184/256)
          love.graphics.line(tx, ty, tx + self.DEFAULT_THICKNESS - 2, ty)
        end
      elseif entity.progress.value > 0 and entity.progress.orientation == "horizontal" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", x, y, size + 2, self.DEFAULT_THICKNESS)

        setProgressBarColor(entity.progress)
        love.graphics.rectangle("fill", x + 1, y + 1, normalizedProgress, self.DEFAULT_THICKNESS - 2)

        if entity.progress.threshold ~= nil then
          local tx = x + 1 + normalizedThreshold
          local ty = y + 1
          love.graphics.setColor(176/256, 167/256, 184/256)
          love.graphics.line(tx, ty, tx, ty + self.DEFAULT_THICKNESS - 2)
        end
      end
    end
  end,
}

return ProgressBarSystem
