local wezterm = require("wezterm")
local act = wezterm.action

local module = {}

-- detects if the focus is in neovim
local function is_vim(pane)
	local process_info = pane:get_foreground_process_info()
	local process_name = process_info and process_info.name

	return process_name == "nvim" or process_name == "vim"
end

local direction_keys = {
	Left = "h",
	Down = "j",
	Up = "k",
	Right = "l",
	-- reverse lookup
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

local function copy_mode_keys()
	local keys = wezterm.gui.default_key_tables().copy_mode

	-- overrides the default keymap
	table.insert(keys, {
		key = "y",
		mods = "NONE",
		action = act.Multiple({
			{ CopyTo = "ClipboardAndPrimarySelection" },
			{ CopyMode = "ClearSelectionMode" },
		}),
	})

	return {
		copy_mode = keys,
	}
end

--- @param config { leader: table, keys: table, key_tables: { copy_mode: table } }
function module.apply_to_config(config)
	config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }

	config.key_tables = copy_mode_keys()

	config.keys = {
		{ key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{
			key = "z",
			mods = "LEADER",
			action = act.TogglePaneZoomState,
		},
		{
			key = "y",
			mods = "LEADER",
			action = act.ActivateCopyMode,
		},
		-- Create a new workspace with a random name and switch to it
		{ key = "c", mods = "LEADER", action = act.SwitchToWorkspace },
		{ key = "n", mods = "LEADER", action = act.SwitchWorkspaceRelative(1) },
		{ key = "p", mods = "LEADER", action = act.SwitchWorkspaceRelative(-1) },
		split_nav("move", "h"),
		split_nav("move", "j"),
		split_nav("move", "k"),
		split_nav("move", "l"),
	}
end

return module
