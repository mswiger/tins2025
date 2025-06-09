local function TrashBundle(assets, x, y)
  local drawable = assets:get("assets/trash.png")
  return {
    name = "trash",
    drawable = drawable,
    regularDrawable = drawable,
    highlightDrawable = assets:get("assets/trash-hover.png"),
    highlightable = true,
    position = {
      x = x,
      y = y,
    },
    layer = 1,
    trash = true,
  }
end

return TrashBundle
