declare-option -docstring 'Width of file picker in percentage of window' str ide_file_picker_width 20
declare-option -docstring 'Width of terminal in percentage of window' str ide_terminal_width 20
declare-option -docstring 'File picker command' str ide_file_picker "broot"

define-command ide %{
    ide-background
    connect ide-file-picker %opt{ide_file_picker}
    connect ide-terminal
}

define-command ide-background %{
    face global Default rgb:bfc7d5,rgb:292d3e
}

define-command tmux-terminal-horizontal-before -params 1.. -shell-completion -docstring '
tmux-terminal-horizontal-before <program> [<arguments>]: create a new terminal as a tmux pane
The current pane is split into two, left and right
The program passed as argument will be executed in the new terminal' \
%{
    tmux-terminal-impl 'split-window -hb' %arg{@}
}

define-command ide-file-picker -params 1.. -shell-completion -docstring '
ide-file-picker <program> [<arguments>]: open file picker panel' \
%{
    tmux-terminal-impl "split-window -hb -p %opt{ide_file_picker_width}" %arg{@}
}

define-command ide-terminal -params 1.. -shell-completion -docstring '
ide-terminal <program> [<arguments>]: open terminal panel' \
%{
    tmux-terminal-impl "split-window -h -p %opt{ide_terminal_width}" %arg{@}
}
