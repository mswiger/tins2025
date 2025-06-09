local function StorageBundle(x, y, width, height, type, id)
  return {
    available = true,
    position = {
      x = x,
      y = y,
    },
    size = {
      width = width,
      height = height,
    },
    storage = {
      id = id,
      type = type,
      filled = false,
    },
  }
end

return StorageBundle
