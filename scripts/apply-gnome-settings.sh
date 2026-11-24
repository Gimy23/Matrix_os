#!/usr/bin/env bash
# ==============================================================================
# MATRIX OS — Native GNOME 51.1 Settings Applicator
# Prefers native GNOME GSettings over extensions; configures Dash-to-Dock only
# if already installed and GNOME 51 compatible.
# ==============================================================================
set -euo pipefail

WALLPAPER_URI="file://${HOME}/.local/share/backgrounds/matrix-os-1920x1080.png"

echo "Applying native GNOME 51.1 settings..."

# Dark mode & native GNOME green accent (GNOME 47–51)
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface accent-color 'green' || true

# GTK3, Icons, Cursor, Monospace font
gsettings set org.gnome.desktop.interface gtk-theme 'Matrix-OS'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 11'

# Wallpaper (both dark and default keys for consistency)
gsettings set org.gnome.desktop.background picture-uri "${WALLPAPER_URI}"
gsettings set org.gnome.desktop.background picture-uri-dark "${WALLPAPER_URI}"
gsettings set org.gnome.desktop.background picture-options 'zoom'

# Subtle performance-friendly defaults (preserve compositor & animations)
gsettings set org.gnome.desktop.interface enable-animations true

# Enable User Themes extension if installed and apply Matrix-OS Shell theme
USER_THEME_UUID="user-theme@gnome-shell-extensions.gcampax.github.com"
if command -v gnome-extensions >/dev/null 2>&1; then
  if gnome-extensions info "${USER_THEME_UUID}" >/dev/null 2>&1; then
    gnome-extensions enable "${USER_THEME_UUID}" || true
    gsettings set org.gnome.shell.extensions.user-theme name 'Matrix-OS' || true
    echo "  [OK] Enabled User Themes and applied 'Matrix-OS' shell theme"
  else
    echo "  [WARN] User Themes extension not found; shell CSS theme will activate once installed."
  fi

  # Optional minimal Dash-to-Dock styling (only if already installed)
  DTD_UUID="dash-to-dock@micxgx.gmail.com"
  if gnome-extensions info "${DTD_UUID}" >/dev/null 2>&1; then
    gsettings set org.gnome.shell.extensions.dash-to-dock custom-theme-shrink true || true
    gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED' || true
    gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.92 || true
    gsettings set org.gnome.shell.extensions.dash-to-dock custom-background-color true || true
    gsettings set org.gnome.shell.extensions.dash-to-dock background-color '#0A100B' || true
    gsettings set org.gnome.shell.extensions.dash-to-dock running-indicator-style 'DOTS' || true
    gsettings set org.gnome.shell.extensions.dash-to-dock running-indicator-dominant-color false || true
    gsettings set org.gnome.shell.extensions.dash-to-dock custom-theme-running-dots-color '#00FF41' || true
    echo "  [OK] Configured minimal Matrix styling for Dash to Dock"
  fi
fi

echo "GNOME settings applied."
