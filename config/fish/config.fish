# ==============================================================================
# MATRIX OS — Fish Shell Configuration
# Minimal, fast, zero external prompt frameworks
# ==============================================================================

# Disable welcome greeting
set -g fish_greeting ""

# Load Matrix OS syntax highlighting palette
if test -f ~/.config/fish/conf.d/matrix_colors.fish
    source ~/.config/fish/conf.d/matrix_colors.fish
end

# Git prompt settings (native Fish, zero extra processes when outside git repos)
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_showcolorhints 1
set -g __fish_git_prompt_color_branch 00C853 --bold
set -g __fish_git_prompt_color_dirtystate FFD54F
set -g __fish_git_prompt_color_untrackedfiles 8FAF99
set -g __fish_git_prompt_color_cleanstate 00FF41
set -g __fish_git_prompt_char_stateseparator " "
set -g __fish_git_prompt_char_dirtystate "*"
set -g __fish_git_prompt_char_untrackedfiles "+"
set -g __fish_git_prompt_char_cleanstate ""

# Interactive-only conveniences
if status is-interactive
    # Clean, safe defaults
    alias ll="ls -lh --color=auto"
    alias la="ls -lAh --color=auto"
    alias grep="grep --color=auto"
end
