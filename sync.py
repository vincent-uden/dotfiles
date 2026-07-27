#!/usr/bin/env python3

import os
import platform
import shutil
import sys
from pathlib import Path

import inquirer

REPO_PATH = Path("./")
BACKUP_DIR = REPO_PATH / ".backup"

MAPPINGS_LINUX = {
    "zed/": Path.home() / ".config" / "zed",
    "zed/config.json": Path.home() / ".config" / "zed" / "config.json",
    "nvim": Path.home() / ".config" / "nvim",
    ".wezterm.lua": Path.home() / ".wezterm.lua",
    "config.nu": Path.home() / ".config" / "config.nu",
    "hypr": Path.home() / ".config" / "hypr",
    "kitty": Path.home() / ".config" / "kitty",
    "chromium/chromium-flags.conf": Path.home() / ".config" / "chromium-flags.conf",
    "helium/helium-browser-flags.conf": Path.home()
    / ".config"
    / "helium-browser-flags.conf",
    # pi: only sync user config, skills, and extensions.
    # auth.json (secrets), sessions/, working/, ext-logs/, and npm/ are runtime/installed data.
    "pi/settings.json": Path.home() / ".pi" / "agent" / "settings.json",
    "pi/skills": Path.home() / ".pi" / "agent" / "skills",
    "pi/extensions": Path.home() / ".pi" / "agent" / "extensions",
    "wofi": Path.home() / ".config" / "wofi",
}

appdata = Path(os.environ.get("APPDATA", Path.home() / "AppData" / "Roaming"))
userprofile = Path(os.environ.get("USERPROFILE", Path.home()))
scripter_scripts = (
    userprofile
    / "AppData"
    / "Local"
    / "Microsoft"
    / "PowerToys"
    / "CommandPalette"
    / "Scripter"
    / "Scripts"
)

MAPPINGS_WINDOWS = {
    "zed/settings.json": appdata / "Zed" / "settings.json",
    "zed/keymap.json": appdata / "Zed" / "keymap.json",
    "nvim": appdata / ".." / "Local" / "nvim",
    ".wezterm.lua": userprofile / ".wezterm.lua",
    "config.nu": appdata / "nushell/config.nu",
    # pi: only sync user config, skills, and extensions.
    # auth.json (secrets), sessions/, working/, ext-logs/, and npm/ are runtime/installed data.
    "pi/settings.json": Path.home() / ".pi" / "agent" / "settings.json",
    "pi/skills": Path.home() / ".pi" / "agent" / "skills",
    "pi/extensions": Path.home() / ".pi" / "agent" / "extensions",
    "scripter/theme-picker.js": scripter_scripts / "theme-picker.js",
    "scripter/theme-picker.js.meta.json": scripter_scripts / "theme-picker.js.meta.json",
}

current_os = platform.system()
if current_os == "Windows":
    MAPPINGS = MAPPINGS_WINDOWS
elif current_os == "Linux":
    MAPPINGS = MAPPINGS_LINUX
else:
    print(f"Unsupported OS: {current_os}")
    sys.exit(1)

# Mapping from program names to their config keys
PROGRAM_KEYS = {
    "zed": ["zed/", "zed/config.json"]
    if current_os == "Linux"
    else ["zed/settings.json", "zed/keymap.json"],
    "nvim": ["nvim"],
    "wezterm": [".wezterm.lua"],
    "nushell": ["config.nu"],
    "hypr": ["hypr"] if current_os == "Linux" else [],
    "kitty": ["kitty"] if current_os == "Linux" else [],
    "chromium": ["chromium/chromium-flags.conf"],
    "helium": ["helium/helium-browser-flags.conf"],
    "pi": ["pi/settings.json", "pi/skills", "pi/extensions"],
    "scripter": ["scripter/theme-picker.js", "scripter/theme-picker.js.meta.json"]
    if current_os == "Windows"
    else [],
    "wofi": ["wofi"] if current_os == "Linux" else [],
}


def backup(path):
    if path.exists() or path.is_symlink():
        backup_dir = path.parent / ".backup"
        backup_dir.mkdir(exist_ok=True)
        backup_path = backup_dir / path.name
        try:
            if path.is_dir():
                shutil.copytree(path, backup_path)
            else:
                shutil.copy2(path, backup_path)
            print(f"Backed up {path} to {backup_path}")
        except Exception as e:
            print(f"Failed to backup {path}: {e}")


def export_configs(selected_programs=None):
    mappings = MAPPINGS
    if selected_programs:
        # Filter mappings to only selected programs
        selected_keys = []
        for prog in selected_programs:
            selected_keys.extend(PROGRAM_KEYS.get(prog, []))
        mappings = {k: v for k, v in MAPPINGS.items() if k in selected_keys}

    for repo_rel, target in mappings.items():
        src = target
        dest = REPO_PATH / repo_rel
        if not src.exists():
            print(f"Source missing: {src}")
            continue
        dest.parent.mkdir(parents=True, exist_ok=True)
        if dest.exists():
            backup(dest)
        try:
            if src.is_dir():
                shutil.copytree(src, dest, dirs_exist_ok=True)
            else:
                shutil.copy2(src, dest)
            print(f"Exported {src} to {dest}")
        except Exception as e:
            print(f"Failed to export {src} to {dest}: {e}")


def import_configs(selected_programs=None):
    mappings = MAPPINGS
    if selected_programs:
        # Filter mappings to only selected programs
        selected_keys = []
        for prog in selected_programs:
            selected_keys.extend(PROGRAM_KEYS.get(prog, []))
        mappings = {k: v for k, v in MAPPINGS.items() if k in selected_keys}

    for repo_rel, target in mappings.items():
        src = REPO_PATH / repo_rel
        dest = target
        if not src.exists():
            print(f"Repo path missing: {src}")
            continue
        dest.parent.mkdir(parents=True, exist_ok=True)
        if dest.exists() or dest.is_symlink():
            backup(dest)
        try:
            if src.is_dir():
                shutil.copytree(src, dest, dirs_exist_ok=True)
            else:
                shutil.copy2(src, dest)
            print(f"Imported {src} to {dest}")
        except Exception as e:
            print(f"Failed to import {src} to {dest}: {e}")


def clear_backups():
    if BACKUP_DIR.exists():
        try:
            shutil.rmtree(BACKUP_DIR)
            print(f"Cleared backup directory: {BACKUP_DIR}")
        except Exception as e:
            print(f"Failed to clear backups: {e}")
    else:
        print(f"Backup directory does not exist: {BACKUP_DIR}")


def main():
    if not REPO_PATH.exists():
        print(f"Repository not found: {REPO_PATH}")
        sys.exit(1)

    # Define available programs
    PROGRAMS = [
        "zed",
        "nvim",
        "wezterm",
        "nushell",
        "hypr",
        "kitty",
        "chromium",
        "helium",
        "pi",
        "wofi",
    ]

    # Prompt for operation
    operation_question = [
        inquirer.List(
            "operation",
            message="What would you like to do?",
            choices=[
                ("Export: Save current system configs to the repository", "export"),
                ("Import: Apply repository configs to the system", "import"),
                ("Clear backups: Remove all backup files", "clear-backups"),
                ("Quit", "quit"),
            ],
        )
    ]
    answers = inquirer.prompt(operation_question)
    if answers is None:
        return  # User pressed Ctrl+C or similar
    operation = answers["operation"]

    if operation == "quit":
        print("Goodbye!")
        return

    if operation in ["export", "import"]:
        # Prompt for program selection
        program_question = [
            inquirer.Checkbox(
                "programs",
                message="Select programs to sync (use space to select, enter to confirm)",
                choices=PROGRAMS + ["quit"],
            )
        ]
        answers = inquirer.prompt(program_question)
        if answers is None:
            return
        selected_programs = answers["programs"]

        if "quit" in selected_programs or not selected_programs:
            print("No programs selected or quit selected. Exiting.")
            return

        if operation == "export":
            export_configs(selected_programs)
        else:
            import_configs(selected_programs)
    else:
        # Clear backups with confirmation
        confirm_question = [
            inquirer.Confirm(
                "confirm",
                message="Are you sure you want to clear all backup files?",
                default=False,
            )
        ]
        answers = inquirer.prompt(confirm_question)
        if answers is None:
            return
        if answers["confirm"]:
            clear_backups()
        else:
            print("Operation cancelled.")


if __name__ == "__main__":
    main()
