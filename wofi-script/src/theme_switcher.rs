use anyhow::{Result, anyhow};
use libc::{SIGUSR1, kill};
use std::{
    fs,
    io::Write,
    path::PathBuf,
    process::{Command, Stdio},
};

#[derive(Debug)]
struct Theme {
    name: String,
    dark: bool,
    kitty_contents: Option<&'static str>,
    neovim_name: Option<String>,
    wofi_contents: Option<&'static str>,
}

fn mutate_line(lines: &mut [String], marker: &str, new_contents: &str) -> Result<()> {
    if let Some(i) = lines.iter_mut().find(|line| line.contains(marker)) {
        i.clear();
        i.push_str(new_contents);
        Ok(())
    } else {
        Err(anyhow!("Couldnt locate marker: {}", marker))
    }
}

fn expand_tilde(path: &str) -> PathBuf {
    if let Some(rest) = path.strip_prefix("~/") {
        home::home_dir().unwrap().join(rest)
    } else {
        PathBuf::from(path)
    }
}

fn kitty_pids() -> Vec<i32> {
    let out = Command::new("pgrep").arg("kitty").output().unwrap();
    String::from_utf8_lossy(&out.stdout)
        .lines()
        .filter_map(|l| l.parse().ok())
        .collect()
}

/// Overwrites ~/.config/wofi/style.css
#[cfg(target_os = "linux")]
fn set_wofi_theme(theme_contents: &str) -> Result<()> {
    let config_path = expand_tilde("~/.config/wofi/style.css");
    config_path.parent().map(fs::create_dir_all).transpose()?;
    fs::write(&config_path, theme_contents)?;
    Ok(())
}

/// Overwrites ~/.config/kitty/theme.conf
fn set_kitty_theme(theme_contents: &str) -> Result<()> {
    let config_path = expand_tilde("~/.config/kitty/theme.conf");
    if !config_path.exists() {
        return Err(anyhow!(
            "Kitty config file doesn't exist at {:?}",
            config_path
        ));
    }
    fs::write(&config_path, theme_contents)?;

    for pid in kitty_pids() {
        unsafe {
            kill(pid, SIGUSR1);
        }
    }

    Ok(())
}

fn set_neovim_theme(theme_name: &str, dark: bool) -> Result<()> {
    let config_path = expand_tilde("~/.config/nvim/lua/configs.lua");
    if !config_path.exists() {
        return Err(anyhow!(
            "Neovim config file doesn't exist at {:?}",
            config_path
        ));
    }
    let mut lines: Vec<String> = fs::read_to_string(&config_path)?
        .lines()
        .map(String::from)
        .collect();
    mutate_line(
        &mut lines,
        "-- marker[colorscheme]",
        &format!(
            "vim.cmd.colorscheme \'{}\' -- marker[colorscheme]",
            theme_name
        ),
    )?;
    mutate_line(
        &mut lines,
        "-- marker[background]",
        &format!(
            "vim.o.background = \'{}\' -- marker[background]",
            if dark { "dark" } else { "light" }
        ),
    )?;

    let new_contents = lines.join("\n");
    fs::write(&config_path, new_contents)?;

    Ok(())
}

pub fn cmd_theme_switcher() -> Result<()> {
    let themes = vec![
        Theme {
            name: "Tokyo Night (Night)".into(),
            dark: true,
            kitty_contents: Some(include_str!("../themes/tokyo-night/kitty.conf")),
            neovim_name: Some("tokyonight-night".into()),
            wofi_contents: Some(include_str!("../../wofi/style-tokyo-night.css")),
        },
        Theme {
            name: "Gruvbox Light".into(),
            dark: false,
            kitty_contents: Some(include_str!("../themes/gruvbox-light/kitty.conf")),
            neovim_name: Some("gruvbox".into()),
            wofi_contents: Some(include_str!("../../wofi/style-gruvbox-light.css")),
        },
        Theme {
            name: "Monoglow".into(),
            dark: true,
            kitty_contents: Some(include_str!("../themes/monoglow/monoglow_z.conf")),
            neovim_name: Some("monoglow-z".into()),
            wofi_contents: Some(include_str!("../../wofi/style-monoglow.css")),
        },
    ];

    let mut child = Command::new("wofi")
        .args(["-n", "--show", "dmenu", "-W", "700", "-H", "600", "-i"])
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()?;

    {
        let stdin = child.stdin.as_mut().unwrap();
        let mut input = String::new();
        for t in &themes {
            input.push_str(&t.name);
            input.push('\n');
        }
        stdin.write_all(input.as_bytes())?;
    }

    let output = child.wait_with_output()?;
    let picked_name = String::from_utf8_lossy(&output.stdout);

    if let Some(theme) = themes.iter().find(|t| t.name == picked_name.trim()) {
        if let Some(contents) = theme.kitty_contents {
            set_kitty_theme(contents)?;
        }
        if let Some(name) = &theme.neovim_name {
            set_neovim_theme(name, theme.dark)?;
        }
        #[cfg(target_os = "linux")]
        if let Some(contents) = theme.wofi_contents {
            set_wofi_theme(contents)?;
        }
    }

    Ok(())
}
