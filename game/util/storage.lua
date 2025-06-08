local function computeStoragePos(storage, drawable)
  local x = storage.position.x + (storage.size.width - drawable:getWidth()) / 2
  local y = storage.position.y + (storage.size.height - drawable:getHeight())
  return x, y
end

return { computeStoragePos = computeStoragePos }
