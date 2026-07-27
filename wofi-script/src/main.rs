use anyhow::Result;
use clap::{Parser, Subcommand};

use crate::audio_switcher::cmd_audio_switcher;
use crate::theme_switcher::cmd_theme_switcher;

pub mod audio_switcher;
pub mod theme_switcher;

#[derive(Parser, Debug)]
struct Args {
    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand, Debug)]
enum Command {
    SwitchTheme,
    SwitchAudio,
}

fn main() -> Result<()> {
    let args = Args::parse();

    match args.command {
        Command::SwitchTheme => cmd_theme_switcher(),
        Command::SwitchAudio => cmd_audio_switcher(),
    }
}
