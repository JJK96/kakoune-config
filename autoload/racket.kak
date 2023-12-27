hook global BufCreate .*\.([^\.]+)\.(pp|scrbl) %{
    evaluate-commands %sh{
        case $kak_hook_param_capture_2 in
            pp)
                lang="pollen"
                char="◊"
                ;;
            scrbl)
                lang="scribble"
                char="@"
                ;;
        esac
        case $kak_hook_param_capture_1 in
            md)
                sublang="markdown"
                ;;
            asciidoc)
                sublang="asciidoc"
                ;;
        esac
        printf "try %%{
            require-module $sublang
            require-module lisp
        }
        echo -debug %%{$lang}
        set buffer filetype $lang
        add-highlighter buffer/$sublang ref $sublang
        add-highlighter buffer/$lang regions
        add-highlighter buffer/$lang/exp region -recurse \( $char\( \) ref lisp
        map buffer insert <c-s> $char"
    }
}

hook global WinSetOption filetype=racket %{
    set window tabstop 2
    set window indentwidth 2
}

hook global WinCreate .*\.rkt %{
    set buffer filetype lisp
    set buffer indentwidth 2
}
