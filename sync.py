#!/usr/bin/env python3

import os
import shutil
from pathlib import Path
import sys
import platform
import argparse

REPO_PATH = Path("./")
BACKUP_DIR = REPO_PATH / ".backup"

MAPPINGS_LINUX = {
    # Neovim
    "nvim": Path.home() / ".config" / "nvim",
    # Wezterm
    ".wezterm.lua": Path.home() / ".wezterm.lua",
    # Nu shell
    "config.nu": Path.home() / ".config" / "config.nu",
    # Hyprland
    "hypr": Path.home() / ".config" / "hypr",
}

appdata = Path(os.environ.get("APPDATA", Path.home() / "AppData" / "Roaming"))
userprofile = Path(os.environ.get("USERPROFILE", Path.home()))

MAPPINGS_WINDOWS = {
    # Neovim
    "nvim": appdata / ".." / "Local" / "nvim",
    # Wezterm
    ".wezterm.lua": userprofile / ".wezterm.lua",
    # Nu shell
    "config.nu": appdata / "nushell/config.nu",
}

current_os = platform.system()
if current_os == "Windows":
    MAPPINGS = MAPPINGS_WINDOWS
elif current_os == "Linux":
    MAPPINGS = MAPPINGS_LINUX
else:
    print(f"Unsupported OS: {current_os}")
    sys.exit(1)


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


def export_configs():
    for repo_rel, target in MAPPINGS.items():
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


def import_configs():
    for repo_rel, target in MAPPINGS.items():
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
    parser = argparse.ArgumentParser(
        description="Sync dotfiles between repo and system."
    )
    parser.add_argument(
        "operation",
        choices=["export", "import", "clear-backups"],
        help='"export" to save system configs to repo, "import" to apply repo configs to system, "clear-backups" to remove all backup files',
    )
    args = parser.parse_args()
    if args.operation == "export":
        export_configs()
    elif args.operation == "import":
        import_configs()
    else:
        clear_backups()


if __name__ == "__main__":
    main()
