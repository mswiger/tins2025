local SpeechBubbleSystem = class {
  query = { "speech" },

  init =  function(self, assets)
    self.assets = assets
  end,

  process = function(self, entities)
    local speechBubble = entities[1]

    if not speechBubble then
      return
    end

    love.graphics.setFont(self.assets:get("assets/bitstream-vera-mono-bold.ttf", 8))
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(speechBubble.speech, speechBubble.position.x, speechBubble.position.y + 20, 75, "center")
  end,
}

return SpeechBubbleSystem
