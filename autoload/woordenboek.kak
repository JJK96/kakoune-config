define-command -hidden woordenboek-impl -params 2 %{
    require-module fzf
    fzf -items-cmd "woordenboek %arg{1} %arg{2}" -kak-cmd "set-register dquote"
}

define-command rijmwoorden -params 1 %{
    woordenboek-impl rijmwoorden %arg{1}
}

define-command synoniemen -params 1 %{
    woordenboek-impl synoniemen %arg{1}
}

define-command woordenboek-mappings %{
    require-module fzf
    set-option buffer fzf_use_main_selection false
    set-option buffer fzf_preview_tmux_height 100%
    set-option buffer fzf_tmux_height 100%
    map -docstring "Rijmwoorden" buffer user r %{: rijmwoorden %val{selection}<ret>}
    map -docstring "Synoniemen" buffer user s %{: synoniemen %val{selection}<ret>}
}
