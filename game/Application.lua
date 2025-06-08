local AssetManager = require("game.AssetManager")

local BowlBundle = require("game.bundles.BowlBundle")

local RenderingSystem = require("game.systems.RenderingSystem")

local Application = class {
  INTERNAL_RES_W = 640,
  INTERNAL_RES_H = 360,

  init = function(self)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setBackgroundColor(0.17, 0.12, 0.19)

    self.assets = AssetManager()
    self.background = self.assets:get("assets/background.png")

    local scaleFactor = math.min(
      love.graphics.getWidth() / self.INTERNAL_RES_W,
      love.graphics.getHeight() / self.INTERNAL_RES_H
    )
    self.camera = Camera(self.INTERNAL_RES_W / 2, self.INTERNAL_RES_H / 2, scaleFactor)

    self.cosmos = Cosmos()
    self.cosmos:addSystems("draw", RenderingSystem())

    self.cosmos:spawn(BowlBundle(self.assets, 40, 143))
  end,

  update = function(self, dt)
    self.cosmos:emit("update", dt)
  end,

  draw = function(self)
    self.camera:attach()
    love.graphics.draw(self.background, 0, 0)
    self.cosmos:emit("draw")
    self.camera:detach()
  end,
}

return Application
