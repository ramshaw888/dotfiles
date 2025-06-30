SOUND_BLACKLIST=(
    'gs'
    'gl'
    'gd'
    '^ls(\s|$)'
    '^cd(\s|$)'
    '^pwd(\s|$)'
    '^echo(\s|$)'
    '^cat(\s|$)'
    '^which(\s|$)'
    '^whoami(\s|$)'
    '^date(\s|$)'
    '^clear(\s|$)'
    '^exit(\s|$)'
    '^history(\s|$)'
    '^ps(\s|$)'
    '^top(\s|$)'
    '^htop(\s|$)'
    '^vim?(\s|$)'
    '^nano(\s|$)'
    '^emacs(\s|$)'
)

_last_command=""

preexec() {
    _last_command="$1"
}

precmd() {
    local exit_code=$?
    # Skip if no command was run
    [[ -z "$_last_command" ]] && return
    # Check if command matches any blacklist pattern
    local should_skip=false
    for pattern in "${SOUND_BLACKLIST[@]}"; do
        if [[ "$_last_command" =~ $pattern ]]; then
            should_skip=true
            break
        fi
    done
    # Skip sound if blacklisted
    if [[ "$should_skip" == true ]]; then
        _last_command=""
        return
    fi
    # Extract the base command name (first word, remove path)
    local cmd_name=$(echo "$_last_command" | awk '{print $1}' | xargs basename)

    if [[ $exit_code -eq 0 ]]; then
        # Success
        (afplay /System/Library/Sounds/Frog.aiff &)
        # (say -r 250 -v "Daniel" "$_last_command" &)
    else
        # Failure
        (afplay /System/Library/Sounds/Sosumi.aiff &)
        # (say -v "Daniel" "$_last_command" &)
    fi
    _last_command=""
}
