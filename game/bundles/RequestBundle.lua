local function RequestBundle()
  return {
    request = {
      layers = 1,
      previousLayers = 1,
      fulfilled = false,
    }
  }
end

return RequestBundle
