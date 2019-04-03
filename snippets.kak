hook global WinSetOption filetype=(latex|markdown) %[
    set -add buffer snippets \
"begin" "\\begin" %{ snippets-insert %{\begin{${1}}
\end{$1}}} \
"matrix" "\\matrix" %{ snippets-insert %{\left[\begin{matrix}
$1
\end{matrix}\right]}} \
"header" "^header" %{ snippets-insert %{---
author: Jan-Jaap Korpershoek (s1726900)
title: $1
---
}} \
"subsection" "^ss " %{ snippets-insert %{\subsection*{$1}}} \
"section" "^s " %{ snippets-insert %{\section*{$1}}} \
"align" "\\align" %{ snippets-insert %{\begin{align*}
$1
\end{align*}}} \
"mod" "\\mod" %{ snippets-insert %{\text{ mod } $1}} \
"image" "^\h*image" %{ snippets-insert %{\begin{figure}
\includegraphics[width=\textwidth]{$1}
\caption{$2}
\end{figure}}} \
"fraction" "\\frac" %{ snippets-insert %{\frac{$1}{$2}$0}}
]

hook global WinSetOption filetype=(c|cpp) %[
set -add buffer snippets \
"for" "for" %{snippets-insert %{for $1; $2; $3 {
	$0
}}}
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
print_r($result);
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
