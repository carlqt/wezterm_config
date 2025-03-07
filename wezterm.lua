local keymaps = require("keymaps")
local config = {}

config.window_close_confirmation = "NeverPrompt"

keymaps.apply_to_config(config)

return config
