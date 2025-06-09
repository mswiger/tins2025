local TinHighlightSystem = class {
  query = {
    held = { "grabbable", "held" },
    tin = { "tin", "position", "highlightable" },
  },

  process = function(_, entities)
    local heldItem = entities.held[1]
    local tin = entities.tin[1]

    if not tin then
      return
    end

    if (heldItem and heldItem.bowl == true and heldItem.contents and #heldItem.contents > 0) or (not heldItem) then
      tin.highlightable = true
    else
      tin.highlightable = false
    end
  end,
}

return TinHighlightSystem
