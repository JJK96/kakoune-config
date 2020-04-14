declare-option str speedrun_character
declare-option str speedrun_file "/tmp/srb2_speedrun_time"

hook global WinCreate (.*\.speedrun|.*speedruns) %[
    set-option window filetype speedrun 
]

hook global WinSetOption filetype=speedrun %|
    map window normal <ret> ': speedrun-select<ret>'
    map window normal ] ': speedrun-next-section<ret>'
    map window normal [ ': speedrun-previous-section<ret>'
    map window normal f ': speedrun-read-file<ret>'
    hook window ModeChange push:insert:normal %[
        evaluate-commands -draft write
    ]
|

define-command speedrun-next-section %{
    execute-keys ]pjj
    speedrun-find-character
}

define-command speedrun-previous-section %{
    execute-keys [p[pj
    speedrun-find-character
}

define-command -hidden speedrun-find-character %{
    try %{
        evaluate-commands %sh{
            if [ -z $kak_opt_speedrun_character ]; then
                echo fail
            fi
        }
        set-register / "- %opt{speedrun_character}"
        execute-keys <a-i>ps<ret>gi
    }
}

define-command -hidden speedrun-select %{
    evaluate-commands -draft -save-regs '"' %{
        execute-keys -save-regs "" gilley
        set-option window speedrun_character %reg{dquote}
    }
    execute-keys gif:llGl
}

define-command speedrun-read-file %{
    evaluate-commands %sh{
        . "$kak_opt_speedrun_file"
        echo "try %{"
            echo "set-register / %{(?i)$map}"
            echo "execute-keys /<ret>"
            echo "set-register / %{\\\\b$skin\\\\b}"
            echo "execute-keys <a-i>ps<ret>"
            echo "speedrun-select"
        echo "}"
        echo "set-register dquote %{$time}"
        echo "info %{Time: $time}"
    }
}
