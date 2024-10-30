# Common aliases
alias ll='ls -lh'
alias la='ls -lha'
alias l='ls -CF'
alias em='emacs -nw'
alias dd='dd status=progress'
alias _='sudo'
alias _i='sudo -i'

# Convienence 
alias rev='nc -lvp 9001'
alias http='python3 -m http.server 8000'

# Crack Map Exec Backwards Compatibility
crackmapexec_alias_func() {
    cme "$@"
}

alias crackmapexec='crackmapexec_alias_func'

# Help people find 7z2john
7z2john_alias_func() {
    7z2john.pl "$@"
}

alias 7z2john='7z2john_alias_func'

# Help people find enum4linux-ng
enum4linux_ng_alias_func() {
    enum4linux-ng "$@"
}

alias enum4linux='enum4linux_ng_alias_func'

# Help people find things
find_string_alias_func() {
    if [ -z "$1" ]; then
        echo "Searches for a string in all files in a directory"
        echo "Usage: find_string <directory> <string>"
        return
    fi
    find $1 -name '*' -exec grep -i "$2" {} \; -print 2>/dev/null
}

alias find_string='find_string_alias_func'
