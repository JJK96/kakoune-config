hook global WinSetOption filetype=(latex|markdown) %[
    set -add buffer snippets \
"header" "^header" %{ snippets-insert %{---
author: Jan-Jaap Korpershoek (s1726900)
title: $1
---
}}
]

hook global WinSetOption filetype=python %[
    set -add buffer snippets \
"interact" "interact" %{ snippets-insert %{import code
code.interact(local=dict(globals(), **locals()))}}
]


hook global WinSetOption filetype=(rust|c|cpp|java) %[
    set -add buffer snippets \
    "comment" "/\*" %{snippets-insert %{/*
 * $1
 */}}
]

hook global WinSetOption filetype=(php) %[
    set -add buffer snippets \
    "print_r" "print_r" %{snippets-insert %{echo '<pre>';
print_r($1);
echo '</pre>';
exit;}}

]

# Tab expand configuration by andreyorst (https://github.com/occivink/kakoune-snippets/issues/9#issuecomment-455810125)
map global insert '<tab>' "z<a-;>: snippets-expand-or-jump 'tab'<ret>"

# hook global InsertCompletionShow .* %{
#     try %{
#         execute-keys -draft 'h<a-K>\h<ret>'
#         map window insert '<tab>' "z<a-;>: snippets-expand-or-jump 'tab'<ret>"
#     }
# }

# hook global InsertCompletionHide .* %{
#     unmap window insert '<tab>' "z<a-;>: snippets-expand-or-jump 'tab'<ret>"
# }

define-command snippets-expand-or-jump -params 1 %{
    execute-keys <backspace>
    try %{
        snippets-expand-trigger %{
            reg / "%opt{snippets_triggers_regex}\z"
            exec 'hGhs<ret>'
        }
    } catch %{
        snippets-select-next-placeholders
    } catch %sh{
        case $1 in
            ret|tab)
                printf "%s\n" "execute-keys -with-hooks <$1>" ;;
            *)
                printf "%s\n" "execute-keys -with-hooks $1" ;;
        esac
    }
}
