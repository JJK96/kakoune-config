define-command termshot-highlight %{
    # Surround with highlighting tags
    execute-keys -save-regs "" _Z
    evaluate-commands -save-regs '"' %{
        set-register dquote '[31;0m'
        execute-keys Pz
        set-register dquote '[0m'
        execute-keys pz
    }
}

hook global BufSetOption filetype=termshot %{
    map -docstring "Highlight" buffer user h ": termshot-highlight<ret>"
}

hook global WinCreate "/tmp/termshot.*" %{
    set-option buffer filetype termshot
}
