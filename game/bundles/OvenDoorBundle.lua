local function OvenDoorBundle(assets, x, y)
  local drawable = assets:get("assets/oven.png")
  return {
    name = "ovenDoor",
    ovenDoor = true,
    drawable = drawable,
    regularDrawable = drawable,
    highlightDrawable = assets:get("assets/oven-hover.png"),
    closedDrawable = drawable,
    closedHighlightDrawable = assets:get("assets/oven-hover.png"),
    openDrawable = assets:get("assets/oven-open.png"),
    openHighlightDrawable = assets:get("assets/oven-open-hover.png"),
    highlightable = true,
    open = false,
    position = {
      x = x,
      y = y,
    },
    layer = 2,
  }
end

return OvenDoorBundle
