hook global BufCreate .*\.rsync-filter %{
    set-option buffer filetype rsync
}

hook global WinSetOption filetype=rsync %{
    map window normal <ret> %{<a-x><a-X>|xargs -I{} find "{}/" -maxdepth 1<ret>}
    hook -always -once global WinSetOption filetype=.* %{
        unmap window normal <ret>
    }
}
