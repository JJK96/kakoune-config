define-command termshot-highlight %{
    # Surround with highlighting tags
    execute-keys _
    evaluate-commands -save-regs '"' %{
        set-register dquote '[31;0m'
        execute-keys P
        set-register dquote '[0m'
        execute-keys p
    }
}

hook global BufSetOption filetype=termshot %{
    map -docstring "Highlight" buffer user h ": termshot-highlight<ret>"
}

hook global WinCreate "/private/var/folders.*termshot\d*" %{
    set-option buffer filetype termshot
}
