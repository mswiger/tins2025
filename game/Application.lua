local AssetManager = require("game.AssetManager")

local BowlBundle = require("game.bundles.BowlBundle")

local HighlightSystem = require("game.systems.HighlightSystem")
local ProgressBarSystem = require("game.systems.ProgressBarSystem")
local RenderingSystem = require("game.systems.RenderingSystem")

local Application = class {
  INTERNAL_RES_W = 640,
  INTERNAL_RES_H = 360,

  init = function(self)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setBackgroundColor(0.17, 0.12, 0.19)

    self.assets = AssetManager()

    local scaleFactor = math.min(
      love.graphics.getWidth() / self.INTERNAL_RES_W,
      love.graphics.getHeight() / self.INTERNAL_RES_H
    )
    self.camera = Camera(self.INTERNAL_RES_W / 2, self.INTERNAL_RES_H / 2, scaleFactor)

    self.cosmos = Cosmos()
    self.cosmos:addSystems("update", HighlightSystem(self.camera))
    self.cosmos:addSystems("draw", RenderingSystem(), ProgressBarSystem())

    self.cosmos:spawn({
      name = "background",
      position = { x = 0, y = 0, },
      drawable = self.assets:get("assets/background.png"),
      layer = 0,
    })
    self.cosmos:spawn(BowlBundle(self.assets, 40, 143))
  end,

  update = function(self, dt)
    self.cosmos:emit("update", dt)
  end,

  draw = function(self)
    self.camera:attach()
    self.cosmos:emit("draw")
    love.graphics.setFont(self.assets:get("assets/bitstream-vera-mono-bold.ttf", 18))
    love.graphics.setColor(0.92, 0.15, 0.25)
    love.graphics.print("00:30", 512, 19)
    love.graphics.setColor(1, 1, 1, 1)
    self.camera:detach()
  end,
}

return Application
