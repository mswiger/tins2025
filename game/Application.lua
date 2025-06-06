local Application = class {
  init = function(self)
    self.cosmos = Cosmos()
  end,

  update = function(self, dt)
    self.cosmos:emit("update", dt)
  end,

  draw = function(self)
    self.cosmos:emit("draw")
  end,
}

return Application
