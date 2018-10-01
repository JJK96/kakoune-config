define-command edit-or-dir -file-completion  -params 1.. %{
    evaluate-commands %sh{
        echo "try %{ delete-buffer! *dir* }"
        if [ -d "$1" ]; then
            case "$1" in
                /*) dir="$1"        ;;
                ..*) dir="$(pwd)/$1" prev="/$(basename $(pwd))<ret>;";;
                *)  dir="$(pwd)/$1" ;;
            esac
            echo "change-directory %{$dir}"
            echo "display-dir-buffer %{$1}"
            echo "try %{ execute-keys %{$prev}}"
        else
            echo "edit %{$@}"
        fi
    }
}

define-command -hidden -params 1 display-dir-buffer %{
    edit -scratch *dir*
    set-option window filetype 'file_select'
    execute-keys "!ls<space>-p<space>--group-directories-first<space><ret>ggO..<esc>"
}

hook global WinSetOption filetype=file_select %{
    map window normal <ret> %{ x_y:edit-or-dir<space>'<c-r>"'<ret> }
    map window normal <backspace> %{ :edit-or-dir<space>..<ret> }
    add-highlighter window/dir regex '^.+/$' 0:list
}

