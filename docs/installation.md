# Installation Guide — Matrix OS (Fedora 44 / GNOME 51.1)

## Prerequisites

All packages are installed from official Fedora DNF repositories (no Snap, no third-party root scripts):

| Package | Purpose |
| :--- | :--- |
| `kitty` | GPU-accelerated terminal emulator |
| `fish` | Interactive shell with native Git prompt & syntax highlighting |
| `papirus-icon-theme` | High-contrast `Papirus-Dark` icon set |
| `gnome-shell-extension-user-theme` | Enables loading `~/.themes/Matrix-OS/gnome-shell/gnome-shell.css` |
| `gnome-tweaks` | Optional GUI to inspect active GTK/Shell/Icon themes |
| `jetbrains-mono-fonts-all` | Monospaced typography for terminal and shell |

## Step-by-Step Installation

1. **Inspect your environment** (read-only):
   ```bash
   ./check-system.sh
   ```
2. **Run the installer** (as your normal user, never as `root`):
   ```bash
   ./install.sh
   ```
   The installer will:
   - Prompt before running `sudo dnf install` for any missing packages listed above.
   - Run `./backup.sh` to snapshot `~/.config/{kitty,fish,gtk-3.0,gtk-4.0}` and GNOME `dconf` keys.
   - Install files strictly into `~/.themes/Matrix-OS`, `~/.config/`, and `~/.local/share/backgrounds/`.
   - Apply GNOME 51.1 `gsettings` via `scripts/apply-gnome-settings.sh`.
3. **Log out and log back in** on Wayland so GNOME Shell 51.1 loads the new shell stylesheet.

## Uninstalling or Restoring

```bash
./uninstall.sh
```
This removes `~/.themes/Matrix-OS` and the wallpaper, then invokes `./restore.sh` to restore your pre-install `dconf` settings and config directories.
