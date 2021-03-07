define-command ide %{
    nop %sh{
        #kak_client, kak_session
        (
        alacritty -t FileManager -e /usr/bin/bash -i -c br &
        alacritty -t Terminal &
        ) >/dev/null 2>&1
    }
    ide-background
}

define-command ide-background %{
    face global Default rgb:bfc7d5,rgb:292d3e
}
