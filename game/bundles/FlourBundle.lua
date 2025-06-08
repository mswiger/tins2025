local function FlourBundle(assets, x, y)
  local drawable = assets:get("assets/flour.png")
  return {
    name = "flour",
    drawable = drawable,
    regularDrawable = drawable,
    highlightDrawable = assets:get("assets/flour-hover.png"),
    highlightable = true,
    layer = 1,
    position = {
      x = x,
      y = y,
    },
  }
end

return FlourBundle
