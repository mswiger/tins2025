VALID_LAYER_COUNTS = { 1, 2, 3, 5, 8 }

local function randLayers()
  return VALID_LAYER_COUNTS[math.random(#VALID_LAYER_COUNTS)]
end

return {
  randLayers = randLayers,
}
