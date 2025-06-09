local TextBundle = require "game.bundles.TextBundle"
local TimerSystem = class {
  query = {
    request = { "request" },
    timer = { "timer" },
  },

  process = function(_, entities, commands, dt)
    local request = entities.request[1].request
    local timer = entities.timer[1]

    if request.fulfilled then
      return
    end

    timer.time = math.max(timer.time - dt, 0)

    local minutes = math.floor(timer.time / 60)
    local seconds = timer.time % 60

    timer.text.value = string.format("%02d:%02d", minutes, seconds)

    if timer.time < 0.01 then
      local loseText = TextBundle("Game over! No more time! \nClick to try again . . .", 95, 65, { 1, 1, 1 }, 22)
      loseText.interstitial = true
      request.failed = true
      commands:spawn(loseText)
    end
  end,
}

return TimerSystem
