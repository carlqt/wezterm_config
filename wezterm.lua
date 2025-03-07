local wezterm = require("wezterm")
local keymaps = require("keymaps")
local config = {}

config.window_close_confirmation = "NeverPrompt"

keymaps.apply_to_config(config)

wezterm.on("update-right-status", function(window, pane)
	local cwd = " " .. pane:get_current_working_dir():sub(8) .. " " -- remove file:// uri prefix
	local date = wezterm.strftime(" %I:%M %p  %A  %B %-d ")
	local hostname = " " .. wezterm.hostname() .. " "

	window:set_right_status(wezterm.format({
		{ Foreground = { Color = "#ffffff" } },
		{ Background = { Color = "#005f5f" } },
		{ Text = cwd },
	}) .. wezterm.format({
		{ Foreground = { Color = "#00875f" } },
		{ Background = { Color = "#005f5f" } },
		{ Text = "" },
	}) .. wezterm.format({
		{ Foreground = { Color = "#ffffff" } },
		{ Background = { Color = "#00875f" } },
		{ Text = date },
	}) .. wezterm.format({
		{ Foreground = { Color = "#00af87" } },
		{ Background = { Color = "#00875f" } },
		{ Text = "" },
	}) .. wezterm.format({
		{ Foreground = { Color = "#ffffff" } },
		{ Background = { Color = "#00af87" } },
		{ Text = hostname },
	}))
end)

return config
