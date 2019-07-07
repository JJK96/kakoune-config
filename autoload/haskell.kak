# haskell bridge for executing things interactively

declare-option -hidden str haskell_bridge_folder "/tmp/kakoune_haskell_bridge/%val{session}"
declare-option -hidden str haskell_bridge_in "%opt{haskell_bridge_folder}/in"
declare-option -hidden str haskell_bridge_out "%opt{haskell_bridge_folder}/out"
declare-option -hidden str haskell_bridge_fifo "%opt{haskell_bridge_folder}/fifo"
declare-option -hidden str haskell_bridge_source %sh{echo "${kak_source%/*}"}
declare-option bool haskell_bridge_fifo_enabled false
declare-option -hidden bool haskell_bridge_running false
declare-option -hidden str-list haskell_bridge_output

hook global GlobalSetOption haskell_bridge_fifo_enabled=true %{
    nop %sh{
        mkfifo $kak_opt_haskell_bridge_fifo
    }
    terminal tail -f %opt{haskell_bridge_fifo}
}

hook global GlobalSetOption haskell_bridge_fifo_enabled=false %{
    nop %sh{
        rm $kak_opt_haskell_bridge_fifo
    }
}

define-command -docstring 'Create FIFOs and start ghci' \
haskell-bridge-start %{
    nop %sh{
        if ! $kak_opt_haskell_bridge_running; then
            mkdir -p $kak_opt_haskell_bridge_folder
            mkfifo $kak_opt_haskell_bridge_in
            mkfifo $kak_opt_haskell_bridge_out
            ( tail -f $kak_opt_haskell_bridge_in | ghci -interactive-print myprint -dynamic ~/Documents/programming/haskell/repl.hs) >/dev/null 2>&1 </dev/null &
            echo ":set args $kak_opt_haskell_bridge_out" > $kak_opt_haskell_bridge_in
        fi
    }
    set-option global haskell_bridge_running true
}

define-command -docstring 'Stop ghci and remove FIFOs' \
haskell-bridge-stop %{
    nop %sh{
        if $kak_opt_haskell_bridge_running; then
            echo ":quit" > $kak_opt_haskell_bridge_in
            rm $kak_opt_haskell_bridge_in
            rm $kak_opt_haskell_bridge_out
            rmdir -p $kak_opt_haskell_bridge_folder
        fi
    }
    set-option global haskell_bridge_fifo_enabled false
    set-option global haskell_bridge_running false
}

define-command -docstring 'Evaluate selections or argument using haskell-bridge return result in " register' \
haskell-bridge-send -params 0..1 %{
    haskell-bridge-start
    set-option global haskell_bridge_output
    evaluate-commands %sh{
        cat_command="cat $kak_opt_haskell_bridge_out"
        if $kak_opt_haskell_bridge_fifo_enabled; then
            cat_command="$cat_command | tee -a $kak_opt_haskell_bridge_fifo"
        fi

        if [ $# -eq 0 ]; then
            eval set -- "$kak_quoted_selections"
        fi
        out=""
        while [ $# -gt 0 ]; do
            output=$(eval $cat_command) && echo "set-option -add global haskell_bridge_output $output" &
            echo "$1" > $kak_opt_haskell_bridge_in &
            wait
            shift
        done
    }
    set-register dquote %opt{haskell_bridge_output}
}

define-command haskell-bridge -params 1.. -shell-script-candidates %{
    for cmd in start stop send;
        do echo $cmd;
    done
} %{ evaluate-commands "haskell-bridge-%arg{1}" }

hook global KakEnd .* %{
    haskell-bridge-stop
}
