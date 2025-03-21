local keymaps = require("keymaps")
local config = {}

config.window_close_confirmation = "NeverPrompt"
config.tab_bar_at_bottom = true

keymaps.apply_to_config(config)

require("statusline").setup()

return config
