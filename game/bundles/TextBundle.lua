local function TextBundle(value, x, y, color, size)
  return {
    position = {
      x = x,
      y = y,
    },
    text = {
      value = value,
      color = color,
      size = size,
    },
  }
end

return TextBundle
