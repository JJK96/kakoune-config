hook global BufCreate .*\.([^\.]+)\.pp %{
    set buffer filetype pollen
    evaluate-commands %sh{
        case $kak_hook_param_capture_1 in
            md)
                lang="markdown"
                ;;
            asciidoc)
                lang="asciidoc"
                ;;
        esac
        printf "try %%{
            require-module $lang
            require-module lisp
        }
        add-highlighter buffer/$lang ref $lang
        add-highlighter buffer/pollen ref pollen" 
    }
    map buffer insert <c-s> ◊
}

add-highlighter shared/pollen regions
add-highlighter shared/pollen/exp region -recurse \( ◊\( \) ref lisp
