hook global ModuleLoaded tmux %[

    define-command tmux-next-vertical %{
        alias global terminal tmux-terminal-vertical
    }

    define-command tmux-next-horizontal %{
        alias global terminal tmux-terminal-horizontal
    }

    define-command tmux-new-horizontal -params .. %{
        tmux-next-horizontal
        new %arg{@}
    }

    define-command tmux-new-vertical -params .. %{
        tmux-next-vertical
        new %arg{@}
    }

    alias global tmux-v tmux-next-vertical
    alias global tmux-h tmux-next-horizontal
    alias global new-h tmux-new-horizontal
    alias global new-v tmux-new-vertical

]
