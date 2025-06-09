local PlateBundle = require("game.bundles.PlateBundle")

local storageUtil = require("game.util.storage")

local NextLevelSystem = class {
  query = {
    request = { "request" },
    text = { "text" },
    plate = { "plate" },
    storage = { "storage" },
    timer = { "timer" },
  },

  init = function(self, assets)
    self.assets = assets
  end,

  process = function(self, entities, commands)
    local request = entities.request[1].request
    local plate = entities.plate[1]
    local timer = entities.timer[1]

    if request.fulfilled or request.failed then
      if request.layers == 8 then
        love.event.quit()
      end
      if request.failed then
        request.failed = false
        request.previousLayers = 1
        request.layers = 1
      else
        request.fulfilled = false
        request.previousLayers = request.layers
        request.layers = request.layers + request.previousLayers
      end
      timer.time = math.max(request.layers * 13, 20)

      for _, textEntity in ipairs(entities.text) do
        if textEntity.interstitial then
          commands:despawn(textEntity)
        end
      end

      local newPlateStorage = storageUtil.emptyStorageFor("counter", entities.storage)
      if newPlateStorage then
        commands:despawn(plate)
        commands:spawn(PlateBundle(self.assets, newPlateStorage))
      end

      for _, storageEntity in ipairs(entities.storage) do
        if storageEntity.storage.type == "window" then
          storageEntity.storage.filled = false
        end
      end
    end
  end,
}

return NextLevelSystem
