local function SpeechBubbleBundle(assets, x, y, speech)
  return {
    name = "speechBubble",
    drawable = assets:get("assets/speech-bubble.png"),
    layer = 1,
    speech = speech,
    position = {
      x = x,
      y = y,
    },
  }
end

return SpeechBubbleBundle
