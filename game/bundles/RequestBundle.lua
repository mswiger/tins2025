local function RequestBundle(layers)
  return {
    request = {
      layers = layers,
      fulfilled = false,
    }
  }
end

return RequestBundle
