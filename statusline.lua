local wezterm = require("wezterm")
local M = {}

function M.setup()
	local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
	tabline.setup({
		options = {
			theme = "Nebula (base16)",
		},
	})
end

return M
