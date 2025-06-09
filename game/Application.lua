local AssetManager = require("game.AssetManager")

local BowlBundle = require("game.bundles.BowlBundle")
local HandBundle = require("game.bundles.HandBundle")
local IngredientBundle = require("game.bundles.IngredientBundle")
local OvenDoorBundle = require("game.bundles.OvenDoorBundle")
local StorageBundle = require("game.bundles.StorageBundle")
local TinBundle = require("game.bundles.TinBundle")
local TrashBundle = require("game.bundles.TrashBundle")

local BakingSystem = require("game.systems.BakingSystem")
local BowlContentsSystem = require("game.systems.BowlContentsSystem")
local GrabSystem = require("game.systems.GrabSystem")
local HighlightSystem = require("game.systems.HighlightSystem")
local ProgressBarSystem = require("game.systems.ProgressBarSystem")
local RenderingSystem = require("game.systems.RenderingSystem")
local OvenDoorSystem = require("game.systems.OvenDoorSystem")
local TinSystem = require("game.systems.TinSystem")
local TrashSystem = require("game.systems.TrashSystem")

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

    self.music = self.assets:get("assets/Jahzzar - Bloom.mp3")
    self.music:setLooping(true)
    self.music:play()

    local scaleFactor = math.min(
      love.graphics.getWidth() / self.INTERNAL_RES_W,
      love.graphics.getHeight() / self.INTERNAL_RES_H
    )
    self.camera = Camera(self.INTERNAL_RES_W / 2, self.INTERNAL_RES_H / 2, scaleFactor)

    self.cosmos = Cosmos()
    self.cosmos:addSystems(
      "primaryAction",
      BowlContentsSystem(self.assets),
      GrabSystem(),
      OvenDoorSystem(self.assets),
      TrashSystem(self.assets),
      TinSystem(self.assets)
    )
    self.cosmos:addSystems("update", BakingSystem(), HighlightSystem(self.camera))
    self.cosmos:addSystems("draw", RenderingSystem(), ProgressBarSystem())

    self.cosmos:spawn({
      name = "background",
      position = { x = 0, y = 0, },
      drawable = self.assets:get("assets/background.png"),
      layer = 0,
    })

    self.cosmos:spawn(HandBundle())

    local COUNTER_STORAGE_W = 100
    local COUNTER_STORAGE_H = 100

    local counter = {
      StorageBundle(40, 99, COUNTER_STORAGE_W, COUNTER_STORAGE_H, "counter", "1"),
      StorageBundle(140, 99, COUNTER_STORAGE_W, COUNTER_STORAGE_H, "counter", "2"),
      StorageBundle(240, 99, COUNTER_STORAGE_W, COUNTER_STORAGE_H, "counter", "3"),
      StorageBundle(340, 99, COUNTER_STORAGE_W, COUNTER_STORAGE_H, "counter", "4"),
    }

    for _, counterBundle in ipairs(counter) do
      self.cosmos:spawn(counterBundle)
    end

    self.cosmos:spawn(BowlBundle(self.assets, counter[1]))
    self.cosmos:spawn(TinBundle(self.assets, counter[2]))

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

    local OVEN_STORAGE_W = 91
    local OVEN_STORAGE_H = 28
    local ovenStorage = StorageBundle(365, 272, OVEN_STORAGE_W, OVEN_STORAGE_H, "oven", "the-oven")
    ovenStorage.available = false
    self.cosmos:spawn(ovenStorage)

    self.cosmos:spawn(IngredientBundle(self.assets, "flour", pantry[1]))
    self.cosmos:spawn(IngredientBundle(self.assets, "sugar", pantry[2]))
    self.cosmos:spawn(IngredientBundle(self.assets, "butter", pantry[5]))
    self.cosmos:spawn(IngredientBundle(self.assets, "eggs", pantry[6]))

    self.cosmos:spawn(TrashBundle(self.assets, 516, 281))

    self.cosmos:spawn(OvenDoorBundle(self.assets, 360, 220))
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
