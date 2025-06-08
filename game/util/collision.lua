local function isPointInBox(px, py, bx, by, bw, bh)
  return px >= bx and px <= bx + bw and py >= by and py <= by + bh
end

return {
  isPointInBox = isPointInBox,
}
