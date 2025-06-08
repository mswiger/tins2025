local function BowlBundle(assets, x, y)
  return {
    name = "bowl",
    drawable = assets:get("assets/bowl.png"),
    layer = 1,
    position = {
      x = x,
      y = y,
    },
  }
end

return BowlBundle
