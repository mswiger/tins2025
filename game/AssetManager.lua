--
-- Built-in loaders
--
local function luaLoader(assets, path)
  return love.filesystem.load(path)()
end

local function imageLoader(assets, path)
  return love.graphics.newImage(path)
end

local function audioLoader(assets, path)
  local info = love.filesystem.getInfo(path, 'file')
  return love.audio.newSource(path, (info and info.size and info.size < 5e5) and 'static' or 'stream')
end

local function fontLoader(assets, path, size)
  return love.graphics.newFont(path, size)
end

local function shaderLoader(assets, path)
  return love.graphics.newShader(path)
end

--
-- Utility
--
local function cacheKey(path, ...)
    local key = path
    local params = { ... }

    for _, param in ipairs(params) do
      key = key .. '|' .. param
    end

    return key
end

--
-- AssetManager
--
local AssetManager = class {
  init = function (self, loaders)
    self.cache = {}
    self.loaders = {
      ['.lua'] = luaLoader,
      ['.png'] = imageLoader,
      ['.jpg'] = imageLoader,
      ['.jpeg'] = imageLoader,
      ['.bmp'] = imageLoader,
      ['.tga'] = imageLoader,
      ['.ogg'] = audioLoader,
      ['.mp3'] = audioLoader,
      ['.wav'] = audioLoader,
      ['.flac'] = audioLoader,
      ['.ttf'] = fontLoader,
      ['.otf'] = fontLoader,
      ['.fnt'] = fontLoader,
      ['.glsl'] = shaderLoader,
    }

    if type(loaders) == 'table' then
      for extension, loader in pairs(loaders) do
        self.loaders[extension] = loader
      end
    end
  end,

  get = function(self, path, ...)
    if love.filesystem.getInfo(path) == nil then
      error("File does not exist: " .. path)
    end

    local key = cacheKey(path, ...)

    if self.cache[key] == nil then
      local extension = nil
      local loader = nil

      repeat
        extension = path:match("%..*$") or ""
        loader = self.loaders[extension]
      until loader ~= nil or extension ~= ""

      if self.loaders[extension] == nil then
        error("No loader registered for file extension '" ..extension .. "'")
      end

      self.cache[key] = self.loaders[extension](self, path, ...)
    end

    return self.cache[key]
  end,

  registerLoader = function(self, extension, loader)
    self.loaders[extension] = loader
  end,

  deregisterLoader = function(self, extension)
    self.loaders[extension] = nil
  end,
}

return AssetManager
