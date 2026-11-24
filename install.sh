#!/usr/bin/env bash
# ==============================================================================
# MATRIX OS — Safe Installer for Fedora 44 / GNOME 51.1 (Wayland)
# - Checks system compatibility
# - Explains every DNF package before installing
# - Creates full backup before modifying any file or setting
# - Installs strictly into user directories (~/.themes, ~/.config, ~/.local)
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${EUID}" -eq 0 ]]; then
  echo "[ERROR] Do not run install.sh as root. Run as your normal user." >&2
  exit 1
fi

echo "========================================================"
echo "  MATRIX OS — Fedora 44 / GNOME 51.1 Theme Installer"
echo "========================================================"

# 1. System check
bash "${SCRIPT_DIR}/check-system.sh"

# 2. Explain and install missing Fedora DNF packages
PACKAGES_TO_INSTALL=()

declare -A PKG_EXPLANATIONS=(
  ["kitty"]="GPU-accelerated terminal emulator configured with Matrix OS palette"
  ["fish"]="Fast, interactive shell with native syntax highlighting and Git prompt"
  ["papirus-icon-theme"]="Papirus Dark icon theme from official Fedora repositories"
  ["gnome-shell-extension-user-theme"]="Official GNOME extension to load ~/.themes/*/gnome-shell/gnome-shell.css"
  ["gnome-tweaks"]="GUI utility to inspect or toggle GTK/Shell/Icon themes"
  ["jetbrains-mono-fonts-all"]="JetBrains Mono typography for terminal and shell UI"
)

check_pkg() {
  local pkg="$1"
  if ! rpm -q "${pkg}" >/dev/null 2>&1; then
    PACKAGES_TO_INSTALL+=("${pkg}")
  fi
}

if command -v rpm >/dev/null 2>&1 && command -v dnf >/dev/null 2>&1; then
  for pkg in kitty fish papirus-icon-theme gnome-shell-extension-user-theme gnome-tweaks jetbrains-mono-fonts-all; do
    check_pkg "${pkg}"
  done

  if [[ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]]; then
    echo ""
    echo "The following Fedora DNF packages are missing and will be installed:"
    for pkg in "${PACKAGES_TO_INSTALL[@]}"; do
      echo "  - ${pkg}: ${PKG_EXPLANATIONS[${pkg}]}"
    done
    read -r -p "Proceed with 'sudo dnf install' for these packages? [y/N] " reply
    if [[ "${reply}" =~ ^[Yy]$ ]]; then
      sudo dnf install -y "${PACKAGES_TO_INSTALL[@]}"
    else
      echo "[INFO] Skipping DNF installation. Continuing with user-space files..."
    fi
  else
    echo "[OK] All recommended Fedora DNF packages are already installed."
  fi
else
  echo "[WARN] dnf/rpm not detected; skipping package installation."
fi

# 3. Backup existing configurations before making any changes
echo ""
bash "${SCRIPT_DIR}/backup.sh"

# 4. Install themes in ~/.themes/Matrix-OS
THEME_DEST="${HOME}/.themes/Matrix-OS"
mkdir -p "${THEME_DEST}/gtk-3.0" "${THEME_DEST}/gnome-shell"
cp -f "${SCRIPT_DIR}/themes/gtk/Matrix-OS/index.theme" "${THEME_DEST}/index.theme"
cp -f "${SCRIPT_DIR}/themes/gtk/Matrix-OS/gtk-3.0/gtk.css" "${THEME_DEST}/gtk-3.0/gtk.css"
cp -f "${SCRIPT_DIR}/themes/shell/Matrix-OS/gnome-shell/gnome-shell.css" "${THEME_DEST}/gnome-shell/gnome-shell.css"
echo "[OK] Installed Matrix-OS GTK3 & GNOME Shell 51.1 theme to ${THEME_DEST}"

# 5. Install GTK3 & GTK4 user overrides
mkdir -p "${HOME}/.config/gtk-3.0" "${HOME}/.config/gtk-4.0"
cp -f "${SCRIPT_DIR}/config/gtk/gtk-3.0/gtk.css" "${HOME}/.config/gtk-3.0/gtk.css"
cp -f "${SCRIPT_DIR}/config/gtk/gtk-4.0/gtk.css" "${HOME}/.config/gtk-4.0/gtk.css"
echo "[OK] Installed GTK3 & GTK4/Libadwaita overrides"

# 6. Install Kitty configuration
mkdir -p "${HOME}/.config/kitty"
cp -f "${SCRIPT_DIR}/config/kitty/kitty.conf" "${HOME}/.config/kitty/kitty.conf"
cp -f "${SCRIPT_DIR}/config/kitty/matrix-os.conf" "${HOME}/.config/kitty/matrix-os.conf"
echo "[OK] Installed Kitty configuration to ${HOME}/.config/kitty"

# 7. Install Fish configuration
mkdir -p "${HOME}/.config/fish/conf.d" "${HOME}/.config/fish/functions"
cp -f "${SCRIPT_DIR}/config/fish/config.fish" "${HOME}/.config/fish/config.fish"
cp -f "${SCRIPT_DIR}/config/fish/conf.d/matrix_colors.fish" "${HOME}/.config/fish/conf.d/matrix_colors.fish"
cp -f "${SCRIPT_DIR}/config/fish/functions/fish_prompt.fish" "${HOME}/.config/fish/functions/fish_prompt.fish"
echo "[OK] Installed Fish configuration to ${HOME}/.config/fish"

# 8. Install static 1920x1080 wallpaper
mkdir -p "${HOME}/.local/share/backgrounds"
cp -f "${SCRIPT_DIR}/wallpapers/matrix-os-1920x1080.png" "${HOME}/.local/share/backgrounds/matrix-os-1920x1080.png"
echo "[OK] Installed wallpaper to ${HOME}/.local/share/backgrounds/matrix-os-1920x1080.png"

# 9. Apply GNOME 51.1 settings
bash "${SCRIPT_DIR}/scripts/apply-gnome-settings.sh"

echo ""
echo "========================================================"
echo "  Installation Complete!"
echo "  Log out and log back in on Wayland to ensure GNOME"
echo "  Shell 51.1 reloads all theme assets cleanly."
echo "========================================================"
