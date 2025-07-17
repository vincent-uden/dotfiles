# Agent Guidelines for Dotfiles Repository

## Commands
- **Sync**: `python3 sync.py export` (save system configs to repo), `python3 sync.py import` (apply repo configs to system)
- **Lint Lua**: `stylua --check .` (check formatting), `stylua .` (format files)
- **No tests**: This is a configuration repository with no test suite

## Code Style
- **Python**: Follow PEP 8, use pathlib for paths, descriptive variable names, proper exception handling
- **Lua**: 2-space indentation, single quotes preferred, no call parentheses (stylua config)
- **JSON**: Standard formatting with 2-space indentation
- **Shell configs**: Follow respective tool conventions (Nu shell, Wezterm, etc.)

## File Structure
- Root contains sync script and main configs (.wezterm.lua, config.nu)
- Tool-specific configs in subdirectories (nvim/, zed/, hypr/, kitty/)
- Backups automatically created in .backup/ during sync operations

## Error Handling
- Always check file existence before operations
- Create parent directories as needed
- Backup files before overwriting
- Handle cross-platform path differences (Windows/Linux)

## Naming Conventions
- Use descriptive function/variable names
- Follow tool-specific conventions for config files
- Maintain consistency with existing patterns