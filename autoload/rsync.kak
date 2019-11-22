hook global WinSetOption filetype=rsync %{
    map global normal <ret> %{<a-x><a-X>|xargs -I{} find "{}/" -maxdepth 1<ret>}
    hook -always -once global WinSetOption filetype=.* %{
        unmap global normal <ret>
    }
}
