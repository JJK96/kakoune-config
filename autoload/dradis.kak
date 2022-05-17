define-command dradis-highlight %{
    # Split selection by line and strip whitespace
    execute-keys "<a-s>_"
    # Surround with highlighting tags
    execute-keys "i$${{<esc>a}}$$<esc>"
}

define-command dradis-unhighlight %{
    execute-keys -draft "s(\$\$\{\{|\}\}\$\$)<ret>d"
}

define-command dradis-snip %{
    execute-keys "c--snip--<esc>"
}

define-command dradis-redact %{
    execute-keys "c[REDACTED]<esc>"
}

define-command -hidden dradis-update-number %{
    #Select number
    execute-keys "s\d+<ret>"
    # Update number
    execute-keys "c<c-r>#<esc>"
}

define-command dradis-update-refs %{
    evaluate-commands -draft %{
        #Select notes
        execute-keys "<percent>s<lt>\d+<gt><ret>"
        dradis-update-number
        #Select footnotes
        execute-keys "<percent>sfn\d+<ret>"
        dradis-update-number
    }
}

hook global BufSetOption filetype=dradis %{
    map -docstring "Highlight" buffer user h ": dradis-highlight<ret>"
    map -docstring "Unhighlight" buffer user H ": dradis-unhighlight<ret>"
    map -docstring "Redact" buffer user r ": dradis-redact<ret>"
    map -docstring "| Redact" buffer user R "|redact<ret>"
}

hook global WinCreate ".*(dradisfs/.*|.issue$)" %{
    set-option buffer filetype dradis
}
