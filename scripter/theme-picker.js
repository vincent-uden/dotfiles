// Theme Picker (Windows only)
// Port of the wofi/kitty theme switcher from ~/Documents/github/dotfiles.
// Targets Wezterm (%USERPROFILE%\.wezterm.lua) and Neovim
// (%LOCALAPPDATA%\nvim\lua\configs.lua) instead of kitty.
// Wezterm reloads its config automatically when the file changes;
// Neovim picks the theme up on next start.

const Interaction = importType(
	"Microsoft.VisualBasic.Interaction, Microsoft.VisualBasic.Core",
);

const home = Environment.GetEnvironmentVariable("USERPROFILE");
const WEZTERM_CONFIG = home + "\\.wezterm.lua";
const NVIM_CONFIG = home + "\\AppData\\Local\\nvim\\lua\\configs.lua";

const WEZTERM_BEGIN = "-- theme-picker:begin";
const WEZTERM_END = "-- theme-picker:end";

// wezterm: Lua inserted between the theme-picker markers in .wezterm.lua.
// Colors are ported from the kitty theme files in the dotfiles repo.
const themes = [
	{
		name: "Tokyo Night (Night)",
		dark: true,
		neovim: "tokyonight-night",
		wezterm: [
			"config.color_schemes = config.color_schemes or {}",
			'config.color_schemes["Theme Picker"] = {',
			'\tforeground = "#c0caf5",',
			'\tbackground = "#1a1b26",',
			'\tcursor_bg = "#c0caf5",',
			'\tcursor_fg = "#1a1b26",',
			'\tcursor_border = "#c0caf5",',
			'\tselection_fg = "#c0caf5",',
			'\tselection_bg = "#283457",',
			'\tansi = { "#15161e", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#bb9af7", "#7dcfff", "#a9b1d6" },',
			'\tbrights = { "#414868", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#bb9af7", "#7dcfff", "#c0caf5" },',
			"\ttab_bar = {",
			'\t\tactive_tab = { bg_color = "#7aa2f7", fg_color = "#16161e" },',
			'\t\tinactive_tab = { bg_color = "#292e42", fg_color = "#545c7e" },',
			"\t},",
			"}",
			'config.color_scheme = "Theme Picker"',
		].join("\n"),
	},
	{
		name: "Gruvbox Light",
		dark: false,
		neovim: "gruvbox",
		wezterm: [
			"config.color_schemes = config.color_schemes or {}",
			'config.color_schemes["Theme Picker"] = {',
			'\tforeground = "#3c3836",',
			'\tbackground = "#fbf1c7",',
			'\tcursor_bg = "#665c54",',
			'\tcursor_fg = "#bdae93",',
			'\tcursor_border = "#665c54",',
			'\tselection_fg = "#3c3836",',
			'\tselection_bg = "#d65d0e",',
			'\tansi = { "#ebdbb2", "#cc241d", "#98971a", "#d79921", "#458588", "#b16286", "#689d6a", "#7c6f64" },',
			'\tbrights = { "#928374", "#9d0006", "#79740e", "#b57614", "#076678", "#8f3f71", "#427b58", "#282828" },',
			"\ttab_bar = {",
			'\t\tactive_tab = { bg_color = "#d79921", fg_color = "#16161e" },',
			'\t\tinactive_tab = { bg_color = "#fbf1c7", fg_color = "#545c7e" },',
			"\t},",
			"}",
			'config.color_scheme = "Theme Picker"',
		].join("\n"),
	},
];

function newlineOf(text) {
	return text.indexOf("\r\n") !== -1 ? "\r\n" : "\n";
}

// Replaces the marked theme block in ~/.wezterm.lua.
function setWeztermTheme(theme) {
	if (!File.Exists(WEZTERM_CONFIG)) {
		throw new Error("Wezterm config not found at " + WEZTERM_CONFIG);
	}
	const text = File.ReadAllText(WEZTERM_CONFIG);
	const re = new RegExp(
		escapeRegex(WEZTERM_BEGIN) + "[\\s\\S]*?" + escapeRegex(WEZTERM_END),
	);
	if (!re.test(text)) {
		throw new Error(
			"Could not locate theme-picker markers in " + WEZTERM_CONFIG,
		);
	}
	const nl = newlineOf(text);
	const block = (WEZTERM_BEGIN + "\n" + theme.wezterm + "\n" + WEZTERM_END)
		.split("\n")
		.join(nl);
	File.WriteAllText(WEZTERM_CONFIG, text.replace(re, block));
}

function escapeRegex(s) {
	return s.replace(/[.*+?^${}()|[\]\\-]/g, "\\$&");
}

// Same marker-based line mutation as the original Rust script.
function mutateLine(lines, marker, newContents) {
	const i = lines.findIndex((l) => l.indexOf(marker) !== -1);
	if (i === -1) {
		throw new Error("Could not locate marker: " + marker);
	}
	const indent = lines[i].match(/^\s*/)[0];
	lines[i] = indent + newContents;
}

// Rewrites the colorscheme/background marker lines in the Neovim config.
function setNeovimTheme(theme) {
	if (!File.Exists(NVIM_CONFIG)) {
		throw new Error("Neovim config not found at " + NVIM_CONFIG);
	}
	const text = File.ReadAllText(NVIM_CONFIG);
	const lines = text.split(/\r?\n/);
	mutateLine(
		lines,
		"-- marker[colorscheme]",
		"vim.cmd.colorscheme '" + theme.neovim + "' -- marker[colorscheme]",
	);
	mutateLine(
		lines,
		"-- marker[background]",
		"vim.o.background = '" +
			(theme.dark ? "dark" : "light") +
			"' -- marker[background]",
	);
	File.WriteAllText(NVIM_CONFIG, lines.join(newlineOf(text)));
}

function pickTheme() {
	const prompt =
		"Pick a theme (number or name):\n\n" +
		themes.map((t, i) => i + 1 + ". " + t.name).join("\n");
	const answer = Interaction.InputBox(prompt, "Theme Picker", "");
	if (!answer) {
		return null; // cancelled
	}
	const trimmed = answer.trim();
	const byNumber = themes[parseInt(trimmed, 10) - 1];
	if (byNumber && String(parseInt(trimmed, 10)) === trimmed) {
		return byNumber;
	}
	return (
		themes.find((t) => t.name.toLowerCase() === trimmed.toLowerCase()) ||
		undefined
	);
}

function main() {
	const theme = pickTheme();
	if (theme === null) {
		return "Cancelled";
	}
	if (theme === undefined) {
		return "No matching theme";
	}
	setWeztermTheme(theme);
	setNeovimTheme(theme);
	return "Applied theme: " + theme.name;
}

main();
