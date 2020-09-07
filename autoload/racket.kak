hook global BufCreate .*\.rkt %{
    set-option buffer filetype lisp
    define-command racket-repl %{
        repl racket -it %val{buffile}
    }
    map buffer normal = ': send-text<ret>'
}
