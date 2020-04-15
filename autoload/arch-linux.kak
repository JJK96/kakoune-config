hook global WinSetOption filetype=packages %[
    map window normal <ret> "<a-x>|xargs pacman -Qi<ret>"
]
