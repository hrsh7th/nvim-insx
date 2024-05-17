local kit = require('insx.kit')
local Cache = require('insx.kit.App.Cache')

---@class insx.kit.App.Config.Schema

---@alias insx.kit.App.Config.SchemaInternal insx.kit.App.Config.Schema|{ revision: integer }

---@class insx.kit.App.Config
---@field private _cache insx.kit.App.Cache
---@field private _default insx.kit.App.Config.SchemaInternal
---@field private _global insx.kit.App.Config.SchemaInternal
---@field private _filetype table<string, insx.kit.App.Config.SchemaInternal>
---@field private _buffer table<integer, insx.kit.App.Config.SchemaInternal>
local Config = {}
Config.__index = Config

---Create new config instance.
---@param default insx.kit.App.Config.Schema
function Config.new(default)
  local self = setmetatable({}, Config)
  self._cache = Cache.new()
  self._default = default
  self._global = {}
  self._filetype = {}
  self._buffer = {}
  return self
end

---Update global config.
---@param config insx.kit.App.Config.Schema
function Config:global(config)
  local revision = (self._global.revision or 1) + 1
  self._global = config or {}
  self._global.revision = revision
end

---Update filetype config.
---@param filetypes string|string[]
---@param config insx.kit.App.Config.Schema
function Config:filetype(filetypes, config)
  for _, filetype in ipairs(kit.to_array(filetypes)) do
    local revision = ((self._filetype[filetype] or {}).revision or 1) + 1
    self._filetype[filetype] = config or {}
    self._filetype[filetype].revision = revision
  end
end

---Update filetype config.
---@param bufnr integer
---@param config insx.kit.App.Config.Schema
function Config:buffer(bufnr, config)
  bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
  local revision = ((self._buffer[bufnr] or {}).revision or 1) + 1
  self._buffer[bufnr] = config or {}
  self._buffer[bufnr].revision = revision
end

---Get current configuration.
---@return insx.kit.App.Config.Schema
function Config:get()
  local filetype = vim.api.nvim_get_option_value('filetype', { buf = 0 })
  local bufnr = vim.api.nvim_get_current_buf()
  return self._cache:ensure({
    tostring(self._global.revision or 0),
    tostring((self._buffer[bufnr] or {}).revision or 0),
    tostring((self._filetype[filetype] or {}).revision or 0),
  }, function()
    local config = self._default
    config = kit.merge(self._global, config)
    config = kit.merge(self._filetype[filetype] or {}, config)
    config = kit.merge(self._buffer[bufnr] or {}, config)
    config.revision = nil
    return config
  end)
end

---Create setup interface.
---@return fun(config: insx.kit.App.Config.Schema)|{ filetype: fun(filetypes: string|string[], config: insx.kit.App.Config.Schema), buffer: fun(bufnr: integer, config: insx.kit.App.Config.Schema) }
function Config:create_setup_interface()
  return setmetatable({
    ---@param filetypes string|string[]
    ---@param config insx.kit.App.Config.Schema
    filetype = function(filetypes, config)
      self:filetype(filetypes, config)
    end,
    ---@param bufnr integer
    ---@param config insx.kit.App.Config.Schema
    buffer = function(bufnr, config)
      self:buffer(bufnr, config)
    end,
  }, {
    ---@param config insx.kit.App.Config.Schema
    __call = function(_, config)
      self:global(config)
    end,
  })
end

return Config
