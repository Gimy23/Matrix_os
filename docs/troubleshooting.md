# Troubleshooting — GNOME 51.1 & Wayland

## GNOME Shell theme did not apply
1. Confirm `User Themes` is enabled:
   ```bash
   gnome-extensions info user-theme@gnome-shell-extensions.gcampax.github.com
   ```
2. If disabled, enable it and re-apply:
   ```bash
   gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
   gsettings set org.gnome.shell.extensions.user-theme name 'Matrix-OS'
   ```
3. Log out and log back in (Wayland does not support `Alt+F2 -> r` shell restarts).

## Extension disabled after Fedora / GNOME 51 upgrade
GNOME 51 strictly checks `metadata.json` `"shell-version"`. Run `./check-system.sh` to verify whether `user-theme` or `dash-to-dock` declares `"51"`. Update extensions via Fedora DNF or Extension Manager before overriding version checks.

## Flatpak GTK4 apps still use default dark theme
Flatpak sandboxes isolate `~/.config/gtk-4.0`. To allow read-only theme access:
```bash
flatpak override --user --filesystem=xdg-config/gtk-4.0:ro
```

## Kitty falls back to system monospace font
Install `jetbrains-mono-fonts-all` via DNF or JetBrainsMono Nerd Font in `~/.local/share/fonts/` and run `fc-cache -fv`.
