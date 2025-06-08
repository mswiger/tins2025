local function BowlBundle(assets, x, y)
  local drawable = assets:get("assets/bowl.png")
  return {
    name = "bowl",
    drawable = drawable,
    regularDrawable = drawable,
    highlightDrawable = assets:get("assets/bowl-hover.png"),
    highlightable = true,
    layer = 1,
    position = {
      x = x,
      y = y,
    },
  }
end

return BowlBundle
