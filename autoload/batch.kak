hook global BufOpenFile /private/var/folders.*batch\..* %[
    set buffer filetype batch
]

hook global BufSetOption filetype=batch %[
    map buffer normal x <a-s><a-x>H
]
