alias aledit="nvim ~/.bash_aliases"
alias alsource="source ~/.bash_aliases"
alias c='xclip -selection clipboard'
alias cdf='cd $(traverse-directories)'
alias l="ls --icons=always"
alias lg='lazygit'
alias ll="ls --icons=always --all --long --git"
alias ls="eza --group-directories-first"
alias nv='nvim .'
alias nvf='nvim $(fzf)'
alias orca='uv run -p 3.11 --project ~/repos/orca_cli orca_cli'
alias rcedit="nvim ~/.bashrc"
alias rcsource="source ~/.bashrc"
alias sp='kitten icat'
alias td='traverse-directories'
alias tma='tmux attach -t'
alias tms='tmux-sessionizer'
alias uvrt='uv run pytest --show-capture=no --disable-warnings'
alias stt='kitty @ set-tab-title'

# Create directory and cd into it
mkcd () {
    mkdir -p "$1" && cd "$1" || exit
}

# Set test directory, test branch, open current ticket note
set_test_branch() {
    export TB="$(git branch --show-current)"
    sed -i "s/TB=.*/TB=\"$TB\"/" "$HOME/.global"
    echo "Ticket branch (TB) set to: $TB"

    export TD="$HOME/test_data/$TB"
    sed -i "s#TD=.*#TD=\"$TD\"#" "$HOME/.global"
    echo "Test directory (TD) set to: $TD"
}
alias stb=set_test_branch

source_globals() {
    source "$HOME/.global"
}

alias rr="source_globals && echo 'Sourced global variables 🌍'"

alias tn='source_globals && nvim $HOME/notes/ticket_notes/$TB.md'
alias ttdd='source_globals && mkcd $TD'

# fh - repeat history
fh() {
    local command
    command=$(history | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
    echo "$command"
    eval "$command"
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


# Usage query_csv <csv_file> <sql_query> [output_mode]
query_csv() {
    local csv_file="$1"
    local query="$2"

    if [ -z "$csv_file" ] || [ -z "$query" ]; then
        echo "Usage: query_csv <csv_file> <sql_query> [output_mode]"
        echo "Example: query_csv data.csv 'SELECT * FROM data WHERE age > 30' markdown"
        return 1
    fi

    local table_name=${csv_file%.csv}
    local output_mode="$3"
    if [ -z "$output_mode" ]; then
        output_mode="markdown"
    fi

    sqlite3 :memory: -cmd ".mode csv" -cmd ".mode $output_mode" -cmd ".import --csv $csv_file $table_name" "$query"
}

setup_geospatial_db () {
    local files=("$@")

    db_file="/tmp/tmp_geo.db"
    rm -f "$db_file"

    for file in "${files[@]}"; do
        tablename=$(basename "${file%.*}")
        ogr2ogr -f SQLite -dsco SPATIALITE=YES \
                -t_srs "EPSG:3857"  \
                -append "$db_file" \
                -nln "$tablename" \
                "$file"
    done
}

geospatial_query () {
    setup_geospatial_db "$@"
    sqlite3 "/tmp/tmp_geo.db" \
        -cmd "SELECT load_extension('mod_spatialite');" \
        -cmd ".mode markdown" \
        -cmd ".headers on"
}

alias gq=geospatial_query

geospatial_query_one_liner() {
   query="$1"
   shift 1
   setup_geospatial_db "$@"
   sqlite3 "/tmp/tmp_geo.db" \
       -cmd "SELECT load_extension('mod_spatialite');" \
       -cmd ".mode markdown" \
       -cmd ".headers on" \
       "$query"
}

alias gqol=geospatial_query_one_liner

# Assumes `setup_geospatial_db` has already been run and the database is ready to be queried  
custom_geospatial_query_one_liner() {
    query="$1"   
    shift 1    
    command="sqlite3 \"/tmp/tmp_geo.db\" -cmd \"SELECT load_extension('mod_spatialite');\""
    for extra in "$@"; do
        command+=" -cmd \"$extra\""
    done    
    command+=" \"$query\"" 
    eval "$command"
}
alias cgq=custom_geospatial_query_one_liner  

run_sqlit() {
    setup_geospatial_db "$@"
    sqlit
}
alias rsqlit=run_sqlit


# https://unix.stackexchange.com/questions/85391/where-is-the-bash-feature-to-open-a-command-in-editor-documented
_edit_wo_executing() {
    local editor="${EDITOR:-nano}"
    tmpf="$(mktemp).sh"
    printf '%s\n' "$READLINE_LINE" > "$tmpf"
    $editor "$tmpf"
    READLINE_LINE="$(<"$tmpf")"
    READLINE_POINT="${#READLINE_LINE}"
    rm "$tmpf"
}

set -o vi
bind -x '"\C-x\C-e":_edit_wo_executing'

feature_count() {
    layer="$1"
    ogrinfo -al -so "$layer" | grep "Count"
}
alias fc=feature_count

dots=".."
target="cd .."
for((i=0; i<10; i++))
do
    alias "$dots=$target"
    dots+="."
    target+="/.."
done
unset dots target
