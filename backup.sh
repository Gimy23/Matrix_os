#!/usr/bin/env bash
# ==============================================================================
# MATRIX OS — Configuration & GNOME Settings Backup Script
# Creates a timestamped, reversible snapshot before any modification.
# ==============================================================================
set -euo pipefail

if [[ "${EUID}" -eq 0 ]]; then
  echo "[ERROR] Do not run backup.sh as root." >&2
  exit 1
fi

BACKUP_ROOT="${HOME}/.local/share/matrix-desktop-backups"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="${BACKUP_ROOT}/${TIMESTAMP}"

mkdir -p "${BACKUP_DIR}/dconf" "${BACKUP_DIR}/config" "${BACKUP_DIR}/themes"

echo "Creating backup in: ${BACKUP_DIR}"

# 1. Backup GNOME dconf settings
if command -v dconf >/dev/null 2>&1; then
  dconf dump /org/gnome/desktop/interface/ > "${BACKUP_DIR}/dconf/interface.dconf" || true
  dconf dump /org/gnome/desktop/background/ > "${BACKUP_DIR}/dconf/background.dconf" || true
  dconf dump /org/gnome/desktop/screensaver/ > "${BACKUP_DIR}/dconf/screensaver.dconf" || true
  dconf dump /org/gnome/shell/ > "${BACKUP_DIR}/dconf/shell.dconf" || true
  dconf dump /org/gnome/mutter/ > "${BACKUP_DIR}/dconf/mutter.dconf" || true
  echo "  [OK] GNOME dconf settings exported"
else
  echo "  [WARN] dconf not found; skipping dconf dump"
fi

# 2. Backup existing user config directories
backup_dir_if_exists() {
  local src="$1"
  local name="$2"
  if [[ -e "${src}" ]]; then
    cp -a "${src}" "${BACKUP_DIR}/config/${name}"
    echo "  [OK] Backed up ${src}"
  else
    touch "${BACKUP_DIR}/config/${name}.absent"
    echo "  [INFO] ${src} did not exist (recorded for clean uninstall)"
  fi
}

backup_dir_if_exists "${HOME}/.config/kitty" "kitty"
backup_dir_if_exists "${HOME}/.config/fish" "fish"
backup_dir_if_exists "${HOME}/.config/gtk-3.0" "gtk-3.0"
backup_dir_if_exists "${HOME}/.config/gtk-4.0" "gtk-4.0"

# 3. Record latest backup pointer
ln -sfn "${BACKUP_DIR}" "${BACKUP_ROOT}/latest"
echo "Backup complete. Latest pointer -> ${BACKUP_DIR}"
