define-command dradis-highlight %{
    execute-keys "i$${{<esc>a}}$$<esc>"
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
