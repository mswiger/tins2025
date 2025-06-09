local requestUtil = require("game.util.request")

local RequestFulfillmentSystem = class {
  query = {
    request = { "request" },
    storage = { "storage" },
    plate = { "plate" },
    speech = { "speech" },
  },

  process = function(_, entities)
    local plate = entities.plate[1]
    local request = entities.request[1].request
    local speechBubble = entities.speech[1]
    local window

    for _, s in ipairs(entities.storage) do
      if s.storage.type == "window" then
        window = s
      end
    end

    if not window or not window.storage.filled then
      speechBubble.speech = requestUtil.requestText(request)
      return
    end

    if #plate.contents < request.layers then
      speechBubble.speech = "not enough :<"
    elseif #plate.contents == request.layers then
      local wrongIngredients = 0
      local badBake = 0
      local perfectIngredients = 0
      for _, layer in ipairs(plate.contents) do
        if layer.bake ~= "baked" then
          badBake = badBake + 1
        end
        if layer.ingredients == "disaster" then
          wrongIngredients = wrongIngredients + 1
        end
        if layer.ingredients == "perfect" then
          perfectIngredients = perfectIngredients + 1
        end

        if wrongIngredients > 0 and badBake > 0 then
          speechBubble.speech = "disgusting! bad bake!"
        elseif wrongIngredients > 0 then
          speechBubble.speech = "disgusting!"
        elseif badBake > 0 then
          speechBubble.speech = "bad bake!"
        elseif perfectIngredients == #plate.contents then
          speechBubble.speech = "it's perfect! <3"
          request.fulfilled = true
        else
          speechBubble.speech = "not bad, thanks"
          request.fulfilled = true
        end
      end
    else
      speechBubble.speech = "too many~"
    end
  end,
}

return RequestFulfillmentSystem
