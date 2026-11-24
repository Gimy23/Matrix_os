# Customization Guide

## Kitty Terminal (`~/.config/kitty/`)
- `matrix-os.conf` defines the 16-color ANSI palette and surface colors.
- `kitty.conf` sets `JetBrainsMono Nerd Font` (`11.5pt`), `background_opacity 1.0`, and `tab_bar_style separator`.
- If you prefer slight transparency on Wayland, set `background_opacity 0.94` in `kitty.conf` (note: increases compositor blend work slightly on Intel UHD 620).

## Fish Shell (`~/.config/fish/`)
- `conf.d/matrix_colors.fish` sets syntax highlighting and completion pager colors.
- `functions/fish_prompt.fish` renders `<cwd> (<git_branch>) [exit_code] ❯ ` using native `fish_git_prompt`.

## GNOME Shell 51.1 & GTK (`~/.themes/Matrix-OS/` & `~/.config/gtk-4.0/`)
- Edit `~/.themes/Matrix-OS/gnome-shell/gnome-shell.css` to adjust panel height (`30px`), border radius, or accent highlights.
- Edit `~/.config/gtk-4.0/gtk.css` to tweak Libadwaita `@define-color` variables.
