-- Hyprland Lua configuration
-- Migrated from the legacy hyprlang format for Hyprland 0.55+.

-- Monitor configuration is split out into a separate file.
require("monitors")

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local fileManager = "thunar"
local menu = "wofi -n --show drun -W 700 -H 600"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")
	hl.exec_cmd("nextcloud")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
	hl.exec_cmd("/usr/lib/xdg-desktop-portal-gtk")
	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
	hl.exec_cmd("hyprctl setcursor Adwaita 12")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("GL_VRR_ALLOWED", "1")
hl.env("NVD_BACKEND", "direct")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

--------------------
---- CONFIGURATION ----
--------------------

hl.config({
	opengl = {
		nvidia_anti_flicker = true,
	},
	cursor = {
		no_hardware_cursors = true,
	},
	debug = {
		vfr = true,
		disable_logs = true,
	},
	xwayland = {
		enabled = 1,
	},
	general = {
		gaps_in = 5,
		gaps_out = 5,
		border_size = 2,
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},
	decoration = {
		rounding = 10,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 10,
			render_power = 3,
			color = 0xee1a1a1a,
		},
		blur = {
			enabled = false,
			size = 3,
			passes = 0,
			vibrancy = 0.1696,
		},
	},
	animations = {
		enabled = true,
	},
	dwindle = {
		preserve_split = true,
	},
	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = false,
	},
	input = {
		kb_layout = "se",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		repeat_delay = 300,
		repeat_rate = 50,
		follow_mouse = 1,
		sensitivity = -0.3,
		accel_profile = "flat",
		touchpad = {
			natural_scroll = false,
		},
		tablet = {
			output = "DP-3",
			transform = 2,
		},
	},
})

-----------------
---- ANIMATIONS ----
-----------------

hl.animation({ leaf = "windowsOut", enabled = false, speed = 2, bezier = "default" })
hl.animation({ leaf = "windowsIn", enabled = false, speed = 2, bezier = "default" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "default", style = "fade" })

-----------------
---- DEVICES ----
-----------------

hl.device({
	name = "msft0001:02-06cb:cd3e-touchpad",
	sensitivity = 0.2,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal), { description = "Launch terminal" })
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close(), { description = "Kill active window" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager), { description = "Launch file manager" })
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating state" })
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu), { description = "Launch application menu" })
hl.bind(
	mainMod .. " + SHIFT + S",
	hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'),
	{ description = "Take a screenshot and copy to clipboard" }
)
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("~/.config/hypr/screenshot_active.sh"), { locked = true })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(), { description = "Toggle fullscreen" })
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("zen-browser"), { description = "Launch web browser" })

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }), { description = "Move focus left" })
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }), { description = "Move focus right" })
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }), { description = "Move focus up" })
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }), { description = "Move focus down" })

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }), { description = "Move window left" })
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }), { description = "Move window right" })
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }), { description = "Move window up" })
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }), { description = "Move window down" })

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "Switch to workspace " .. i })
	hl.bind(
		mainMod .. " + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = i }),
		{ description = "Move window to workspace " .. i }
	)
end

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Scroll to next workspace" })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Scroll to previous workspace" })

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window with mouse" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window with mouse" })

hl.bind(
	mainMod .. " + S",
	hl.dsp.exec_cmd("~/github/dotfiles/wofi-script/target/release/wofi-script switch-audio"),
	{ description = "Open audio sink selection" }
)
hl.bind(
	mainMod .. " + T",
	hl.dsp.exec_cmd("~/github/dotfiles/wofi-script/target/release/wofi-script switch-theme"),
	{ description = "Open theme picker" }
)
hl.bind(
	mainMod .. " + B",
	hl.dsp.exec_cmd("~/github/dotfiles/wofi/wofi-bluetooth.sh"),
	{ description = "Open bluetooth controls" }
)

hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl -- set-sink-volume 0 -10%"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl -- set-sink-volume 0 +10%"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl -- set-sink-mute 0 toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl -- set-source-mute 0 toggle"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s +10%"))

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
	name = "float-dev-app",
	match = { title = "App" },
	size = "1600 900",
	float = true,
})

hl.window_rule({
	name = "float-figures",
	match = { title = "Figure" },
	float = true,
})

hl.window_rule({
	name = "float-picker",
	match = { class = "xdg-desktop-portal-gtk" },
	float = true,
})
