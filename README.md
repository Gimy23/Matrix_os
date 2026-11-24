# MATRIX OS — Lightweight Fedora 44 / GNOME 51.1 Desktop Theme

A cohesive, Matrix-inspired cybersecurity workstation customization package built specifically for **Fedora Linux 44** running **GNOME Shell 51.1** on **Wayland**, tuned for the **HP EliteBook 830 G5** (Intel Core i5-8350U, 16 GB RAM, Intel UHD Graphics 620, 1920×1080).

## Color Palette

| Role | Hex | Usage |
| :--- | :--- | :--- |
| Main Background | `#050805` | Shell stage, terminal background, GTK window base |
| Secondary Background | `#0A100B` | Sidebars, popovers, quick settings, inactive tabs |
| Surface | `#101A12` | Cards, buttons, dialogs, hover states |
| Primary Green | `#00FF41` | Active indicators, cursor, prompt sigil, focused borders |
| Secondary Green | `#00C853` | Suggested actions, links, active toggles |
| Muted Green | `#4CAF50` | Comments, secondary accents, rain tails |
| Text | `#E0F2E9` | Primary foreground text |
| Secondary Text | `#8FAF99` | Subtitles, inactive labels |
| Borders | `#1D3825` | 1px static borders, selections, dividers |
| Warning / Error | `#FFD54F` / `#FF5252` | Non-zero exit codes, destructive actions, alerts |

## Quick Start

```bash
unzip matrix-desktop.zip
cd matrix-desktop
chmod +x *.sh scripts/*.sh
./check-system.sh
./install.sh
```

Log out and log back in on Wayland so GNOME Shell 51.1 cleanly reloads `Matrix-OS`.

## Hardware Performance Optimizations (Intel UHD Graphics 620)

- **Zero live wallpapers**: Uses a static 1920×1080 PNG (`wallpapers/matrix-os-1920x1080.png`) to eliminate continuous GPU/CPU decode overhead.
- **Zero `backdrop-filter` or heavy shell blur**: All GNOME Shell 51.1 and GTK surfaces use crisp 1px `#1D3825` borders and solid `#050805`/`#0A100B`/`#101A12` fills.
- **Opaque Kitty terminal**: `background_opacity 1.0` avoids Wayland compositor alpha-blending overhead while keeping `sync_to_monitor yes`.
- **Native Fish prompt**: Uses built-in `fish_git_prompt` with zero external prompt frameworks or background daemons.
- **Native GNOME settings first**: Uses `org.gnome.desktop.interface color-scheme 'prefer-dark'` and `accent-color 'green'` ([GNOME 47+ Accent Colors](https://release.gnome.org/47/)) rather than heavy theming extensions.

## GNOME 51.1 & Libadwaita Compatibility Notes

- **User Themes**: Requires `user-theme@gnome-shell-extensions.gcampax.github.com` (supported on GNOME 51).
- **Dash to Dock**: Configured only if already installed; `dash-to-dock` v107/108+ supports GNOME 51 ([GNOME Extensions](https://extensions.gnome.org/extension/307/dash-to-dock/)).
- **Libadwaita / Flatpak**: `~/.config/gtk-4.0/gtk.css` styles native RPM GTK4/libadwaita apps (such as Nautilus). Flatpak apps intentionally isolate `~/.config/gtk-4.0` unless explicitly granted read-only access (`flatpak override --user --filesystem=xdg-config/gtk-4.0:ro`), and apps that hardcode custom styles cannot be overridden via user CSS.

## Safety & Reversibility

`install.sh` automatically runs `backup.sh` before modifying anything, storing a timestamped snapshot of your GNOME `dconf` settings, Kitty, Fish, and GTK configs in `~/.local/share/matrix-desktop-backups/`. Run `./uninstall.sh` or `./restore.sh` at any time to revert cleanly.
