local AssetManager = require("game.AssetManager")

local BowlBundle = require("game.bundles.BowlBundle")
local HandBundle = require("game.bundles.HandBundle")
local IngredientBundle = require("game.bundles.IngredientBundle")
local StorageBundle = require("game.bundles.StorageBundle")

local BowlContentsSystem = require("game.systems.BowlContentsSystem")
local GrabSystem = require("game.systems.GrabSystem")
local HighlightSystem = require("game.systems.HighlightSystem")
local ProgressBarSystem = require("game.systems.ProgressBarSystem")
local RenderingSystem = require("game.systems.RenderingSystem")

local Application = class {
  INTERNAL_RES_W = 640,
  INTERNAL_RES_H = 360,

  init = function(self)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setBackgroundColor(0.17, 0.12, 0.19)

    self.input = baton.new {
      controls = {
        primaryAction = { "mouse:1" },
      },
    }

    self.assets = AssetManager()

    local scaleFactor = math.min(
      love.graphics.getWidth() / self.INTERNAL_RES_W,
      love.graphics.getHeight() / self.INTERNAL_RES_H
    )
    self.camera = Camera(self.INTERNAL_RES_W / 2, self.INTERNAL_RES_H / 2, scaleFactor)

    self.cosmos = Cosmos()
    self.cosmos:addSystems("primaryAction", BowlContentsSystem(), GrabSystem())
    self.cosmos:addSystems("update", HighlightSystem(self.camera))
    self.cosmos:addSystems("draw", RenderingSystem(), ProgressBarSystem())

    self.cosmos:spawn({
      name = "background",
      position = { x = 0, y = 0, },
      drawable = self.assets:get("assets/background.png"),
      layer = 0,
    })
    self.cosmos:spawn(BowlBundle(self.assets, 40, 143))

    self.cosmos:spawn(HandBundle())

    local PANTRY_STORAGE_W = 62
    local PANTRY_STORAGE_H = 42

    local pantry = {
      StorageBundle(26, 218, PANTRY_STORAGE_W, PANTRY_STORAGE_H, "pantry", "top-left"),
      StorageBundle(88, 218, PANTRY_STORAGE_W, PANTRY_STORAGE_H, "pantry", "top-center"),
      StorageBundle(150, 218, PANTRY_STORAGE_W, PANTRY_STORAGE_H, "pantry", "top-right"),
      StorageBundle(26, 264, PANTRY_STORAGE_W, PANTRY_STORAGE_H, "pantry", "middle-left"),
      StorageBundle(88, 264, PANTRY_STORAGE_W, PANTRY_STORAGE_H, "pantry", "middle-center"),
      StorageBundle(150, 264, PANTRY_STORAGE_W, PANTRY_STORAGE_H, "pantry", "middle-right"),
      StorageBundle(26, 312, PANTRY_STORAGE_W, PANTRY_STORAGE_H, "pantry", "bottom-left"),
      StorageBundle(88, 312, PANTRY_STORAGE_W, PANTRY_STORAGE_H, "pantry", "bottom-center"),
      StorageBundle(150, 312, PANTRY_STORAGE_W, PANTRY_STORAGE_H, "pantry", "bottom-right"),
    }

    for _, pantryBundle in ipairs(pantry) do
      self.cosmos:spawn(pantryBundle)
    end

    self.cosmos:spawn(IngredientBundle(self.assets, "flour", pantry[1]))
    self.cosmos:spawn(IngredientBundle(self.assets, "sugar", pantry[2]))
    self.cosmos:spawn(IngredientBundle(self.assets, "butter", pantry[5]))
    self.cosmos:spawn(IngredientBundle(self.assets, "eggs", pantry[6]))
  end,

  update = function(self, dt)
    self.input:update()

    if self.input:pressed("primaryAction") then
      local x, y = self.camera:worldCoords(love.mouse.getPosition())
      self.cosmos:emit("primaryAction", x, y)
    end

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
