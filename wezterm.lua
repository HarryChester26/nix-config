local wezterm = require("wezterm")
-- Optional local modules (not included in the original uploads).
local has_constants, constants = pcall(require, "constants")
local has_commands, commands = pcall(require, "commands")
local config = wezterm.config_builder()

--- Font settings

config.font_size = 16
config.line_height = 1.2
config.font = wezterm.font("JetBrainsMono Nerd Font")

--- Color

config.colors = {
	cursor_bg = "white",
	cursor_border = "white",
}

-- Appearance

config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.cursor_blink_rate = 0
if has_constants and type(constants) == "table" and constants.bg_image then
	config.window_background_image = constants.bg_image
end
-- config.macos_window_background_blur = 40
if wezterm.target_triple:find("darwin", 1, true) then
	config.native_macos_fullscreen_mode = true
end

-- Miscellaneous settings

config.enable_scroll_bar = true -- not working
config.max_fps = 120
config.prefer_egl = true

-- Movement

-- Custom commands

if has_commands and type(commands) == "table" then
	wezterm.on("augment-command-palette", function()
		return commands
	end)
end

-- Keymap settings

return config
