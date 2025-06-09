local function computeStoragePos(storage, drawable)
  local x = storage.position.x + (storage.size.width - drawable:getWidth()) / 2
  local y = storage.position.y + (storage.size.height - drawable:getHeight())
  return x, y
end

local function validStorage(itemStorageType, storageType)
  if type(itemStorageType) == "table" then
    for _, t in ipairs(itemStorageType) do
      if t == storageType then return true end
    end
    return false
  else
    return itemStorageType == storageType
  end
end


return {
  computeStoragePos = computeStoragePos,
  validStorage = validStorage,
}
