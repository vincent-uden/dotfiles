# Dotfiles Sync

A Python script to **export** your system's configuration files to a Git repository and **import** them back, supporting both **Windows** and **Linux**.

## Features
- **Cross-Platform**: Compatible with Windows and Linux.
- **Export & Import**: Sync configurations between your system and repo.
- **Automatic Backups**: Creates backups before overwriting files.
- **Custom Mappings**: Define which files to sync.

## Prerequisites
- **Python 3.x**
- **Git** (for repository management)

## Configuration
Edit `MAPPINGS_LINUX` and `MAPPINGS_WINDOWS` in `sync.py` to define the files to sync. The key is the relative path to the file in the repository, and the value is the path to the file on the system.

## Usage
Run the script from this directory with `python3 sync.py <operation>`, where `<operation>` is either `import` or `export`.

- Export: Saves the current state of the system's configuration files to the repository.
```sh
python sync.py export
```
- Import: Restores the system's configuration files from the repository.
```sh
python sync.py import
```

## Backups
Backups are created before overwriting files. The backup file has the same name as the original file, but with a `.backup` suffix.
