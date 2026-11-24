#!/usr/bin/env bash
# ==============================================================================
# MATRIX OS — Configuration & GNOME Settings Restore Script
# Restores the latest (or specified) backup created by backup.sh.
# ==============================================================================
set -euo pipefail

if [[ "${EUID}" -eq 0 ]]; then
  echo "[ERROR] Do not run restore.sh as root." >&2
  exit 1
fi

BACKUP_ROOT="${HOME}/.local/share/matrix-desktop-backups"
TARGET_BACKUP="${1:-${BACKUP_ROOT}/latest}"

if [[ ! -d "${TARGET_BACKUP}" ]]; then
  echo "[ERROR] No backup found at '${TARGET_BACKUP}'." >&2
  exit 1
fi

echo "Restoring backup from: ${TARGET_BACKUP}"

# 1. Restore GNOME dconf settings
if command -v dconf >/dev/null 2>&1; then
  [[ -s "${TARGET_BACKUP}/dconf/interface.dconf" ]] && dconf load /org/gnome/desktop/interface/ < "${TARGET_BACKUP}/dconf/interface.dconf"
  [[ -s "${TARGET_BACKUP}/dconf/background.dconf" ]] && dconf load /org/gnome/desktop/background/ < "${TARGET_BACKUP}/dconf/background.dconf"
  [[ -s "${TARGET_BACKUP}/dconf/screensaver.dconf" ]] && dconf load /org/gnome/desktop/screensaver/ < "${TARGET_BACKUP}/dconf/screensaver.dconf"
  [[ -s "${TARGET_BACKUP}/dconf/shell.dconf" ]] && dconf load /org/gnome/shell/ < "${TARGET_BACKUP}/dconf/shell.dconf"
  [[ -s "${TARGET_BACKUP}/dconf/mutter.dconf" ]] && dconf load /org/gnome/mutter/ < "${TARGET_BACKUP}/dconf/mutter.dconf"
  echo "  [OK] GNOME dconf settings restored"
fi

# 2. Restore user config directories
restore_dir_entry() {
  local dest="$1"
  local name="$2"
  if [[ -d "${TARGET_BACKUP}/config/${name}" ]]; then
    rm -rf "${dest}"
    cp -a "${TARGET_BACKUP}/config/${name}" "${dest}"
    echo "  [OK] Restored ${dest}"
  elif [[ -f "${TARGET_BACKUP}/config/${name}.absent" ]]; then
    rm -rf "${dest}"
    echo "  [OK] Removed ${dest} (was absent prior to install)"
  fi
}

restore_dir_entry "${HOME}/.config/kitty" "kitty"
restore_dir_entry "${HOME}/.config/fish" "fish"
restore_dir_entry "${HOME}/.config/gtk-3.0" "gtk-3.0"
restore_dir_entry "${HOME}/.config/gtk-4.0" "gtk-4.0"

echo "Restore complete. Log out and back in if GNOME Shell theme changes do not immediately reload."
