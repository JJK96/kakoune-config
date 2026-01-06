hook global BufOpenFile /tmp/batch_.*/.* %[
    set buffer filetype batch
]

hook global BufSetOption filetype=batch %[
    map buffer normal x <a-s><a-x>H
]
