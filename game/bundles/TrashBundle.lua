local function TrashBundle(assets, x, y)
  local drawable = assets:get("assets/trash.png")
  return {
    drawable = drawable,
    regularDrawable = drawable,
    highlightDrawable = assets:get("assets/trash-hover.png"),
    highlightable = false,
    position = {
      x = x,
      y = y,
    },
    layer = 1,
  }
end

return TrashBundle
