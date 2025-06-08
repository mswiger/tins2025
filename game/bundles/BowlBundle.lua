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
    progress = {
      value = 0,
      orientation = "vertical",
      offsetX = 85,
      offsetY = 3,
      size = 50,
    },
    bowlContents = {},
  }
end

return BowlBundle
