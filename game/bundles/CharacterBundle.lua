local function CharacterBundle(assets, x, y)
  return {
    drawable = assets:get("assets/catte.png"),
    layer = 1,
    position = {
      x = x,
      y = y,
    },
  }
end

return CharacterBundle
