define-command -hidden html-auto-close-tag %{
    evaluate-commands -draft -itersel -save-regs '"^' %{
        try %{
            # Check if last entered characters are "</"
            execute-keys -draft hH<a-k><lt><ret>
            # Get tag
            execute-keys -save-regs '' Z[
            execute-keys -with-maps t
            execute-keys -save-regs '' ey
            # Paste tag
            execute-keys -save-regs '' zh<a-p>
            # Close tag
            execute-keys -with-hooks a<gt>
        }
    }
}

hook global WinSetOption filetype=(xml|html|php|svelte) %{
    # Credits to mawww for this mapping
    map -docstring "xml tag object" global object t %{c<lt>([\w.]+)\b[^>]*?(?<lt>!/)>,<lt>/([\w.]+)\b[^>]*?(?<lt>!/)><ret>}
    hook -group "close-tag" window InsertChar '/' html-auto-close-tag

}

