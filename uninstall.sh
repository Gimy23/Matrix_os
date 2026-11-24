#!/usr/bin/env bash
# ==============================================================================
# MATRIX OS — Safe Uninstaller
# Removes Matrix OS theme assets and restores the pre-install backup.
# Never deletes user documents or system-wide files.
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${EUID}" -eq 0 ]]; then
  echo "[ERROR] Do not run uninstall.sh as root." >&2
  exit 1
fi

echo "=== MATRIX OS: Uninstalling ==="

# 1. Remove Matrix-OS theme & wallpaper
rm -rf "${HOME}/.themes/Matrix-OS"
rm -f "${HOME}/.local/share/backgrounds/matrix-os-1920x1080.png"
echo "[OK] Removed Matrix-OS theme directory and wallpaper"

# 2. Restore previous backup if available
BACKUP_LATEST="${HOME}/.local/share/matrix-desktop-backups/latest"
if [[ -d "${BACKUP_LATEST}" ]]; then
  bash "${SCRIPT_DIR}/restore.sh" "${BACKUP_LATEST}"
else
  echo "[WARN] No backup found; resetting GNOME appearance keys to defaults."
  if command -v gsettings >/dev/null 2>&1; then
    gsettings reset org.gnome.desktop.interface gtk-theme || true
    gsettings reset org.gnome.desktop.interface icon-theme || true
    gsettings reset org.gnome.desktop.interface accent-color || true
    gsettings reset org.gnome.desktop.background picture-uri || true
    gsettings reset org.gnome.desktop.background picture-uri-dark || true
    gsettings reset org.gnome.shell.extensions.user-theme name || true
  fi
fi

echo "=== Uninstall Complete. Log out and back in to finalize. ==="
