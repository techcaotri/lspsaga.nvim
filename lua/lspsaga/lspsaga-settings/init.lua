local config = require("lspsaga.lspsaga-settings.config")
local JsonFile = require("lspsaga.lspsaga-settings.json-file")

local M = {
  settings_file = nil,
}

local log = require('lspsaga.lspsaga-settings.vlog')
log.new({ plugin = "lspsaga-vlog.nvim", level = "warn" }, true)

function M:new(setting_name)
  assert(setting_name, "A unique setting name should be passed to the class")
  assert(type(setting_name), "Type of the setting name should be an string")

  local o = {
    key = setting_name,
  }

  setmetatable(o, self)
  self.__index = self
  self.key = setting_name

  -- log.debug("lspsaga-settings key: " .. self.key)
  return o
end

function M:get_settings()
  log.debug("get_settings called")
  local gsettings = M.get_settings_file():read()
  -- log.debug("get_settings: Get settings from file return gsettings: " .. tableToJsonStr(gsettings))
  log.debug("init-get_settings(): gsettings")
  log.debug(vim.inspect(gsettings))
  log.debug("init-get_settings(): self")
  log.debug(vim.inspect(self))
  log.debug("init-get_settings(): self.key: " .. self.key)

  local local_settings
  if gsettings ~= nil and gsettings[self.key] ~= nil then
    local_settings = gsettings[self.key]
  end
  if not local_settings then
    self:save_settings(vim.empty_dict())
    return nil
  end

  return gsettings[self.key]
end

function M:save_settings(settings)
  local gsettings = M.get_settings_file():read()

  log.debug("save_settings called")
  log.debug(vim.inspect(gsettings))
  log.debug("save_settings(): inspect settings:")
  log.debug(vim.inspect(settings))
  local merged_settings = settings
  if gsettings ~= nil and gsettings[self.key] ~= nill then
    merged_settings = vim.tbl_deep_extend("force", gsettings[self.key], settings)
  end

  gsettings[self.key] = merged_settings

  M.get_settings_file():write(gsettings)
end

function M.get_settings_file()
  log.debug("get_settings_file called")
  if not M.settings_file then
    M.settings_file = JsonFile:new(config.file_path)
  end

  return M.settings_file
end

function M.setup(user_config)
  config = vim.tbl_extend(config, user_config)
end

return M
