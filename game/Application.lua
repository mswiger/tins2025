local AssetManager = require("game.AssetManager")

local BowlBundle = require("game.bundles.BowlBundle")
local CharacterBundle = require("game.bundles.CharacterBundle")
local HandBundle = require("game.bundles.HandBundle")
local IngredientBundle = require("game.bundles.IngredientBundle")
local OvenDoorBundle = require("game.bundles.OvenDoorBundle")
local PlateBundle = require("game.bundles.PlateBundle")
local RequestBundle = require("game.bundles.RequestBundle")
local SpeechBubbleBundle = require("game.bundles.SpeechBubbleBundle")
local StorageBundle = require("game.bundles.StorageBundle")
local TextBundle = require("game.bundles.TextBundle")
local TinBundle = require("game.bundles.TinBundle")
local TrashBundle = require("game.bundles.TrashBundle")

local BakingSystem = require("game.systems.BakingSystem")
local BowlContentsSystem = require("game.systems.BowlContentsSystem")
local EmptyPlateSystem = require("game.systems.EmptyPlateSystem")
local GrabSystem = require("game.systems.GrabSystem")
local HighlightSystem = require("game.systems.HighlightSystem")
local NextLevelSystem = require("game.systems.NextLevelSystem")
local PlateContentsSystem = require("game.systems.PlateContentsSystem")
local ProgressBarSystem = require("game.systems.ProgressBarSystem")
local RenderingSystem = require("game.systems.RenderingSystem")
local OvenDoorSystem = require("game.systems.OvenDoorSystem")
local RequestFulfillmentSystem = require("game.systems.RequestFulfillmentSystem")
local SpeechBubbleSystem = require("game.systems.SpeechBubbleSystem")
local TextRenderingSystem = require("game.systems.TextRenderingSystem")
local TimerSystem = require("game.systems.TimerSystem")
local TinSystem = require("game.systems.TinSystem")
local TrashSystem = require("game.systems.TrashSystem")

local Application = class {
  INTERNAL_RES_W = 640,
  INTERNAL_RES_H = 360,

  init = function(self)
    math.randomseed(os.time())

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
      NextLevelSystem(self.assets),
      BowlContentsSystem(self.assets),
      GrabSystem(),
      OvenDoorSystem(self.assets),
      TrashSystem(self.assets),
      TinSystem(self.assets),
      PlateContentsSystem(self.assets)
    )
    self.cosmos:addSystems("update", TimerSystem(), BakingSystem(), HighlightSystem(self.camera), EmptyPlateSystem(self.assets), RequestFulfillmentSystem)
    self.cosmos:addSystems("draw", RenderingSystem(), ProgressBarSystem(), SpeechBubbleSystem(self.assets), TextRenderingSystem(self.assets))

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
    self.cosmos:spawn(PlateBundle(self.assets, counter[4]))

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

    self.cosmos:spawn(StorageBundle(479, 80, 121, 120, "window", "the-window"))

    self.cosmos:spawn(TrashBundle(self.assets, 516, 281))

    self.cosmos:spawn(OvenDoorBundle(self.assets, 360, 220))

    self.cosmos:spawn(RequestBundle())

    self.cosmos:spawn(CharacterBundle(self.assets, 479, 80))
    self.cosmos:spawn(SpeechBubbleBundle(self.assets, 413, 48, ""))

    local timer = TextBundle("", 512, 19, { 0.92, 0.15, 0.25 }, 18)
    timer.timer = true
    timer.time = 20
    self.cosmos:spawn(timer)
  end,

  update = function(self, dt)
    if love.keyboard.isDown("escape") then
      love.event.quit()
    end

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
    love.graphics.setColor(1, 1, 1, 1)
    self.camera:detach()
  end,
}

return Application
