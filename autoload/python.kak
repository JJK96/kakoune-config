hook global WinSetOption filetype=python %{
    alias window comment comment-line
    hook -once -always window WinSetOption filetype=.* %{
        unalias window comment
    }
}
