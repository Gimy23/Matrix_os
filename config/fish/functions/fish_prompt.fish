function fish_prompt --description 'Matrix OS minimal cybersecurity workstation prompt'
    set -l last_status $status

    # Host/user indicator only when SSH or root
    if set -q SSH_TTY
        set_color 8FAF99
        echo -n (prompt_hostname)" "
    end

    # Current working directory (clearly visible)
    set_color 00C853 --bold
    echo -n (prompt_pwd --full-length-dirs 2)

    # Native Git branch & dirty state
    set -l git_info (fish_git_prompt " (%s)")
    if test -n "$git_info"
        echo -n $git_info
    end

    # Command status indicator + prompt sigil
    if test $last_status -ne 0
        set_color FF5252 --bold
        echo -n " [$last_status]"
    end

    if fish_is_root_user
        set_color FF5252 --bold
        echo -n " # "
    else
        set_color 00FF41 --bold
        echo -n " ❯ "
    end
    set_color normal
end
