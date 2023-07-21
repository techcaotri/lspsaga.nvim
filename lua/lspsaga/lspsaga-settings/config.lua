local config_dir = vim.call("stdpath", "config")
local success, error = pcall(get_config_dir)

local log = require('lspsaga.lspsaga-settings.vlog')
log.new({ level = "warn" }, true)

if not success then
  log.debug("Error there's no get_config_dir(): " .. error)
else
  config_dir = get_config_dir()
end

return {
  file_path = require("lvim.utils").join_paths(config_dir, "lspsaga-settings/settings.json"),
}
