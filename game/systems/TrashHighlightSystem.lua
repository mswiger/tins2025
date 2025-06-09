local TrashHighlightSystem = class {
  query = {
    held = { "grabbable", "held", "contents" },
    trash = { "trash", "position", "highlightable" },
  },

  process = function(_, entities)
    local heldItem = entities.held[1]
    local trash = entities.trash[1]

    if not trash then
      return
    end

    if heldItem and heldItem.contents ~= nil then
      trash.highlightable = true
    else
      trash.highlightable = false
    end
  end,
}

return TrashHighlightSystem
