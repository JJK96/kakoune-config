define-command -hidden html-auto-close-tag %{
    evaluate-commands -draft -itersel %{
        try %{
            # Check if last entered characters are "</"
            execute-keys -draft hH<a-k><lt><ret>
            # Get tag
            execute-keys Z[
            execute-keys -with-maps t
            execute-keys e"ay
            # Paste tag
            execute-keys zh"a<a-p>
            # Close tag
            execute-keys -with-hooks a<gt>
        }
    }
}

hook global WinSetOption filetype=(xml|html|php) %{
    map -docstring "xml tag object" global object t %{c<lt>([\w.]+)\b[^>]*?(?<lt>!/)>,<lt>/([\w.]+)\b[^>]*?(?<lt>!/)><ret>}

    hook window InsertChar '/' html-auto-close-tag

}

