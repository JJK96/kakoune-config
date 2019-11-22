# Highlight the word under the cursor
# ───────────────────────────────────
# Based on: https://github.com/mawww/config/blob/d841453cc71f3ab8cbe19ac5036cd86807590617/kakrc#L40-L54

declare-option -hidden regex curword
set-face global CurWord default,rgb:4a4a4a

hook global NormalIdle .* %{
    eval -draft %{ try %{
        exec <space><a-i>w <a-k>\A\w+\z<ret>
        set-option buffer curword "\b\Q%val{selection}\E\b"
    } catch %{
        set-option buffer curword ''
    } }
}
add-highlighter global/ dynregex '%opt{curword}' 0:CurWord
