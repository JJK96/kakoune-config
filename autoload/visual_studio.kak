define-command visual-studio-mappings %{
    map -docstring "Open in visual studio" global user v %{:nop %sh{open_in_vs $kak_buffile}<ret>}
}
