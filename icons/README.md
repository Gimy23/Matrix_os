# Icons and Cursor Policy

Matrix OS uses **Papirus Dark** (`papirus-icon-theme` from the official Fedora DNF repositories) paired with the native **Adwaita** cursor theme:

- **Icon Theme**: `Papirus-Dark` — clean, high-contrast dark icons that pair naturally with `#050805` and `#101A12` surfaces without downloading unverified third-party icon packs.
- **Cursor Theme**: `Adwaita` (default system cursor) — zero extra memory overhead and full Wayland HiDPI/fractional-scaling support. If you later install a green cursor theme from a trusted Fedora package or verified source, update `org.gnome.desktop.interface cursor-theme` in `scripts/apply-gnome-settings.sh`.
