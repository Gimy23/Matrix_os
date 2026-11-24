#!/usr/bin/env bash
# ==============================================================================
# MATRIX OS — System & GNOME 51.1 Compatibility Checker
# Inspects OS, GNOME Shell version, session type, hardware, and dependencies.
# ==============================================================================
set -euo pipefail

echo "=== MATRIX OS: System Compatibility Check ==="

# 1. Refuse root execution
if [[ "${EUID}" -eq 0 ]]; then
  echo "[ERROR] Do not run this script as root. Run as your normal user." >&2
  exit 1
fi

# 2. Detect Fedora version
if [[ -r /etc/os-release ]]; then
  # shellcheck source=/dev/null
  source /etc/os-release
  echo "OS: ${PRETTY_NAME:-Unknown}"
  if [[ "${ID:-}" != "fedora" ]]; then
    echo "[WARN] Target OS is Fedora Linux 44; detected ID='${ID:-unknown}'."
  fi
  if [[ "${VERSION_ID:-}" != "44" ]]; then
    echo "[WARN] Designed for Fedora 44; detected VERSION_ID='${VERSION_ID:-unknown}'."
  fi
else
  echo "[WARN] /etc/os-release not found."
fi

# 3. Detect GNOME Shell version
if command -v gnome-shell >/dev/null 2>&1; then
  GNOME_VER_RAW="$(gnome-shell --version 2>/dev/null || true)"
  echo "Desktop: ${GNOME_VER_RAW}"
  GNOME_MAJOR="$(echo "${GNOME_VER_RAW}" | awk '{print $3}' | cut -d. -f1)"
  if [[ "${GNOME_MAJOR}" != "51" ]]; then
    echo "[WARN] Primary target is GNOME Shell 51.1; detected '${GNOME_VER_RAW}'."
  fi
else
  echo "[ERROR] gnome-shell is not installed or not in PATH." >&2
  exit 1
fi

# 4. Detect Wayland vs X11
SESSION_TYPE="${XDG_SESSION_TYPE:-unknown}"
echo "Session Type: ${SESSION_TYPE}"
if [[ "${SESSION_TYPE}" != "wayland" ]]; then
  echo "[WARN] Designed for Wayland; current session is '${SESSION_TYPE}'."
fi

# 5. Hardware summary (read-only)
if command -v lscpu >/dev/null 2>&1; then
  CPU_MODEL="$(lscpu | awk -F: '/Model name/ {gsub(/^[ \t]+/, "", $2); print $2; exit}')"
  echo "CPU: ${CPU_MODEL:-Unknown}"
fi
if [[ -r /proc/meminfo ]]; then
  MEM_KB="$(awk '/MemTotal/ {print $2}' /proc/meminfo)"
  echo "RAM: $((MEM_KB / 1024 / 1024)) GiB"
fi

# 6. Check required/recommended commands & packages
echo ""
echo "--- Dependency Check ---"
for cmd in kitty fish gsettings dconf gnome-extensions; do
  if command -v "${cmd}" >/dev/null 2>&1; then
    echo "  [OK]   ${cmd}"
  else
    echo "  [MISS] ${cmd}"
  fi
done

# 7. Check Papirus Dark & JetBrains Mono
if [[ -d /usr/share/icons/Papirus-Dark || -d "${HOME}/.local/share/icons/Papirus-Dark" ]]; then
  echo "  [OK]   Papirus-Dark icon theme"
else
  echo "  [MISS] Papirus-Dark icon theme (package: papirus-icon-theme)"
fi

if command -v fc-list >/dev/null 2>&1 && fc-list : family | grep -qi "JetBrains"; then
  echo "  [OK]   JetBrains Mono font family"
else
  echo "  [WARN] JetBrains Mono font not found (package: jetbrains-mono-fonts-all)"
fi

# 8. Check GNOME 51 extension compatibility for user-theme & dash-to-dock
echo ""
echo "--- GNOME 51 Extension Compatibility ---"
check_ext_compat() {
  local uuid="$1"
  local label="$2"
  local user_dir="${HOME}/.local/share/gnome-shell/extensions/${uuid}"
  local sys_dir="/usr/share/gnome-shell/extensions/${uuid}"
  local meta=""
  if [[ -f "${user_dir}/metadata.json" ]]; then
    meta="${user_dir}/metadata.json"
  elif [[ -f "${sys_dir}/metadata.json" ]]; then
    meta="${sys_dir}/metadata.json"
  fi
  if [[ -z "${meta}" ]]; then
    echo "  [MISS] ${label} (${uuid}) not installed"
    return
  fi
  if grep -qE '"51(\.[0-9]+|alpha|beta|rc)?"' "${meta}"; then
    echo "  [OK]   ${label} declares GNOME 51 support (${meta})"
  else
    echo "  [WARN] ${label} metadata.json does not explicitly list GNOME 51 (${meta})"
  fi
}

check_ext_compat "user-theme@gnome-shell-extensions.gcampax.github.com" "User Themes"
check_ext_compat "dash-to-dock@micxgx.gmail.com" "Dash to Dock"
echo "=== Check Complete ==="
