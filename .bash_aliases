alias c='xclip -selection clipboard'

alias lg='lazygit'

alias sp='kitten icat'

alias tms='tmux-sessionizer'

alias nv='nvim .'

alias nvf='nvim $(fzf)'

alias tma='tmux attach -t'

alias td='traverse-directories'

alias cdf='cd $(traverse-directories)'

# Create directory and cd into it
mkcd () {
    mkdir -p "$1" && cd "$1" || exit
}

# fh - repeat history
fh() {
    eval $(history | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# cd into a directory with fzf
# First argument gives the starting directory (defaults to current directory)
fd() {
    if [ -z "$1" ]; then
        local start_dir="."
    else
        local start_dir="$1" 
    fi
    cd "$(find "$start_dir" -type d | fzf --reverse --prompt="Search directories: ")" || exit
}

# rt - run test
# Saves the command to clipboard so that it can easily be re-run without going through fzf again
rt() {
    local start_dir test_to_run command
    if [ -z "$1" ]; then
        start_dir="."
    else
        start_dir="$1" 
    fi
    test_to_run=$(collect_tests.py | fzf)
    if [ -z "$test_to_run" ]; then
        echo "No tests available."
        return 1
    fi
    command="uv run pytest $test_to_run"
    echo "$command" | xclip -selection clipboard
    eval "$command"
}
