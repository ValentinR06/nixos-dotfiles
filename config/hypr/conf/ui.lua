-----------------------
---- LOOK AND FEEL ----
-----------------------
local colors = require("colors").palette
-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 6,
		gaps_out = 12,

		border_size = 2,
		col = {
			active_border = "rgba(" .. colors.accent .. "ee)",
			inactive_border = "rgba(" .. colors.bg_dark .. "a0)",
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 20,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 0.9,
		inactive_opacity = 0.82,

		shadow = {
			enabled = false,
			range = 2,
			render_power = 4,
			color = "rgba(" .. colors.accent .. "50)",
			color_inactive = "rgba(" .. colors.bg_dark .. "80)",
		},

		blur = {
			enabled = true,
			size = 6,
			passes = 3,

			noise = 0.01,
			contrast = 0.8,
			vibrancy = 0.2,
		},
	},
})

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })

hl.window_rule({
	name = "no-gaps-f1",
	match = { float = false, workspace = "f[1]" },
	border_size = 0,
	rounding = 0,
})
