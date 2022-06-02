# relative line numbers
hook global BufCreate .* %[
    add-highlighter buffer/ number-lines -relative -hlcursor
    add-highlighter buffer/ wrap
]

add-highlighter global/ show-matching

# Disable clippy
set-option global ui_options ncurses_assistant=off

# Set jumpclient
set-option global jumpclient jump
# Set toolsclient
set-option global toolsclient tools
# Set docsclient
set-option global docsclient docs
# Create client with name
define-command -docstring "Open a new client with the given name" \
new-client -params 1 %{
    new rename-client %arg{1}
}


# indentation
set-option global tabstop     4
set-option global indentwidth 4

# # tabs to spaces
hook global InsertChar \t %{
    exec -draft h@
}

# keep space around cursor
# set-option global scrolloff 10,10

# save on pressing enter
hook global NormalKey <ret> w

# remap grep-jump
map global goto <ret> "<esc><ret>"

# vim old habits
map global normal D '<a-l>d' -docstring 'delete to end of line'
map global normal Y '<a-l>y' -docstring 'yank to end of line'
map global normal <a-h> Gi

# case insensitive search
map global prompt <a-i> "<home>(?i)<end>"

# user mappings
map global user l -docstring 'lsp' ': enter-user-mode lsp<ret>'

define-command paste %{
    evaluate-commands -save-regs ^ %{
        #Paste
        execute-keys "!pbpaste<ret>"
        #Select 
        execute-keys uU
        #Save selection
        execute-keys -save-regs "" Z
        try %{
            #Remove cariage return before newline
            execute-keys "s\r\n<ret>hd"
        }
        try %{
            #Replace cariage return elsewhere with newline
            execute-keys "zs\r<ret>r<return>"
        }
        #Restore selection
        execute-keys z
    }
}

## clipboard interaction
map global user p -docstring 'paste from clipboard' '! powershell.exe -Command get-clipboard<ret>'
map global user y -docstring 'copy to clipboard' '<a-|>clip.exe<ret>'
map global user d -docstring 'cut to clipboard' '|clip.exe<ret>'

# format
# map global user f -docstring 'format buffer' ':format<ret>'

define-command comment %{
    try %{
        execute-keys _
        comment-block
    } catch comment-line
}

define-command -hidden ctags-search-word %{
    try %{
        execute-keys <a-i>w
    }
    execute-keys ": ctags-search "
}

# comment lines
map global user c -docstring 'comment lines' %{: comment<ret>}

# search with c tags
map global goto s -docstring 'search ctags' %{<esc>: ctags-search-word<ret>}

# Delete buffer and quit
map global normal <c-q> ": db;q<ret>"

# Open file in new window
define-command open-in-new-window -params .. -file-completion %{ new edit "%arg{@}"}
alias global e open-in-new-window

# Terminal, used by ide wrapper
define-command _terminal -params .. %{
  shell \
    -export session \
    -export client \
    %sh(echo $TERMINAL) -e %arg(@) \
    %sh(test $# = 0 &&
      echo $SHELL
    )
}

try %{
    require-module x11
    require-module tmux
}
alias global term _terminal

# Define mappings for when repl is used
define-command repl-mappings -params .. %{
    map buffer normal <backspace> ": repl-send-text<ret>"
    repl-new %arg{@}
}

# file types
hook global BufCreate .*\.xsd %{ set buffer filetype xml }

# kakoune language server

# Depends on https://github.com/ul/kak-lsp
eval %sh{kak-lsp --kakoune -s $kak_session }
# Debug output
# nop %sh{ (kak-lsp -s $kak_session -vvv ) > /tmp/kak-lsp.log 2>&1 < /dev/null & }
# lsp-enable

hook global WinSetOption filetype=(rust|python|php|haskell|c|cpp|latex|c#|racket) %{
    lsp-enable-window
    lsp-auto-hover-enable
    set global lsp_hover_anchor true

    hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
    hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
    hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window semantic-tokens
    }
}

set-option global lsp_server_configuration latex.build.onSave=true
set-option -add global lsp_server_configuration latex.build.args=["-pdf","-pdflatex\=lualatex","-interaction\=nonstopmode","-synctex\=1","%f"]
# set-option -add global lsp_server_configuration latex.build.forwardSearchAfter=true
# set-option -add global lsp_server_configuration latex.forwardSearch.executable="okular"
# set-option -add global lsp_server_configuration latex.forwardSearch.args=["--noraise","--unique","file:%p#src:%l%f"]

#spell
declare-user-mode spell
map global spell a -docstring 'add to dictionary' ": spell-add<ret>" 
map global spell e -docstring 'enable'  ": spell-enable<ret>"
map global spell r -docstring 'replace' ": spell-replace<ret>"
map global spell n -docstring 'next'    ": spell-next<ret>"
map global spell c -docstring 'clear'   ": spell-clear<ret>"
# map global user s -docstring 'spell' ": enter-user-mode -lock spell<ret>"
declare-option str language en-GB
define-command spell-enable %{
    #hook global WinSetOption filetype=(latex|markdown|git-commit) %{
        hook window BufWritePost .* %{
            spell %opt{language}
        }
    #}
}

# modeline
set-option global modelinefmt %{{Error}%sh{[ $kak_opt_lsp_diagnostic_error_count -gt 0 ] && echo "$kak_opt_lsp_diagnostic_error_count"}{StatusLineInfo} %sh{ echo $kak_opt_debugger_indicator } {StatusLine}%val{bufname} %val{cursor_line}:%val{cursor_char_column} {{context_info}} {{mode_info}} - %val{client}@[%val{session}]}
#set-option global modelinefmt %{ %sh{ echo $kak_opt_debugger_indicator } {StatusLine}%val{bufname} %val{cursor_line}:%val{cursor_char_column} {{context_info}} {{mode_info}} - %val{client}@[%val{session}]}

# Disable sql highlighting
set global disabled_hooks '(sql-highlight|php-indent|php-trim-indent|php-insert)'

# Use ripgrep instead of grep
set global grepcmd 'rg -n'

# Plugins

source "%val{config}/plugins/kak-bundle/rc/kak-bundle.kak"
set-option global bundle_path "%val{config}/plugins"

set-option global bundle_do_install_hooks true
set-option global bundle_install_hooks %{
  cd $kak_config/plugins/kak-lsp
  cargo install --locked --force --path .

  cd $kak_config/plugins/parinfer-rust
  cargo install --locked --force --path .
}

bundle-register-and-load \
    "https://codeberg.org/jdugan6240/kak-bundle" %{} \
    "https://github.com/occivink/kakoune-snippets" %{
        set-option global snippets_auto_expand false
        declare-user-mode snippets
        #map global user s -docstring "Snippets" ": enter-user-mode snippets<ret>"
        map global snippets n -docstring "Select next placeholder" ": snippets-select-next-placeholders<ret>"
        map global snippets s -docstring "Snippet" ": snippets "
        map global snippets i -docstring "Info" ": snippets-info<ret>"

        add-highlighter global/ ranges snippets_placeholders 
        set-option global snippets_directories "%opt{bundle_path}kakoune-snippet-collection/snippets" "%opt{bundle_path}northwave/snippets"
        source "%val{config}/snippets.kak"
    } \
    "https://github.com/andreyorst/kakoune-snippet-collection" %{} \
    "https://github.com/occivink/kakoune-sudo-write" %{} \
    "https://github.com/jjk96/kakoune-fireplace" %{} \
    "https://github.com/jjk96/kakoune-extra-filetypes" %{} \
    "https://github.com/robertmeta/prelude.kak" %{} \
    "https://github.com/jjk96/connect.kak" %{
        # depends on prelude.kak
        require-module connect
        require-module connect-broot
        #set-option global connect_environment %{
            #export EDITOR=:e
        #}
    } \
    "https://github.com/Delapouite/kakoune-buffers" %{
        map global user b ': enter-user-mode -lock buffers<ret>'   -docstring 'buffers (lock)…'
    } \
    'https://github.com/delapouite/kakoune-cd' %{
        # Suggested aliases
        alias global cdb change-directory-current-buffer
        alias global cdr change-directory-project-root
        alias global ecd edit-current-buffer-directory
        alias global pwd print-working-directory
    } \
    'https://github.com/Delapouite/kakoune-mirror' %{
        map global user o -docstring 'mirror' ': enter-user-mode mirror<ret>'
        map global mirror * -docstring 'stars (markdown bold)' 'i**<esc>a**<esc>'
        map global mirror $ -docstring '$ (latex math)' 'i$<esc>a$<esc>'
        map global mirror . ': enter-user-mode -lock mirror<ret>'
    } \
    'https://github.com/alexherbo2/split-object.kak' %{
        map global normal <a-L> ': enter-user-mode split-object<ret>'
    } \
    'https://github.com/eraserhd/kak-ansi' %{} \
    'https://github.com/jjk96/kakoune-emmet' %{
        # hook global WinSetOption filetype=(xml|html|svelte) %{
        #     emmet-enable-autocomplete
        # }
    } \
    'https://github.com/jjk96/kakoune-python-bridge' %{
        # calculate
        map global normal = ': python-bridge-send<ret>R'
        map global normal <backspace> ': python-bridge-send<ret>'
        python-bridge-send %{
    from math import *
        }
    } \
    'https://github.com/jjk96/kakoune-repl-bridge' %{
        hook global BufSetOption filetype=haskell %{
            map buffer normal = ': repl-bridge haskell send<ret>R'
            map buffer normal <backspace> ': repl-bridge haskell send<ret>'
        }
    } \
    'https://github.com/jjk96/kakoune-dbgp' %{
        hook global WinSetOption filetype=php %{
            dbgp-enable-autojump
            map global user x -docstring 'debugger' ': enter-user-mode dbgp<ret>'
        }
    } \
    'https://github.com/occivink/kakoune-gdb' %{} \
    "https://github.com/eraserhd/parinfer-rust" %{
        hook global WinSetOption filetype=(clojure|lisp|scheme|racket|pollen|scribble) %{
            parinfer-enable-window -smart
        }
    } \
    "https://github.com/kakoune-repl-send" %{
        hook global BufSetOption filetype=scheme %{
            map buffer normal <backspace> ': repl-send<ret>'
            set buffer repl_send_command "stdbuf -o0 chicken-csi"
            set buffer repl_send_exit_command "(exit)"
        }
    } \
    "https://github.com/https://gitlab.com/fsub/kakoune-mark" %{
        declare-user-mode mark
        map global mark -docstring "mark word" m ": mark-word<ret>"
        map global mark -docstring "clear marks" c ": mark-clear<ret>"
        map global user -docstring "mark" m ": enter-user-mode mark<ret>"
    } \
    "https://github.com/andreyorst/tagbar.kak" %{
        hook global ModuleLoaded tagbar %{
            set-option global tagbar_sort false
            set-option global tagbar_size 40
            set-option global tagbar_display_anon false
            set-option global tagbar_display_anon true
        }
        # if you have wrap highlighter enamled in you configuration
        # files it's better to turn it off for tagbar, using this hook:
        hook global WinSetOption filetype=tagbar %{
            remove-highlighter window/wrap
            # you can also disable rendering whitespaces here, line numbers, and
            # matching characters
        }
    } \
    'https://github.com/delapouite/kakoune-palette' %{} \
    'https://github.com/TeddyDD/kakoune-edit-or-dir' %{} \
    'https://github.com/jjk96/kakoune-rainbow' %{} \
    'https://github.com/occivink/kakoune-find' %{} \
    "https://gitlab.com/listentolist/kakoune-table" %{} \
    "https://github.com/andreyorst/fzf.kak" %{
        map global user f -docstring "fzf" ': fzf-mode<ret>'
    } \
    'https://github.com/chambln/kakoune-kit' %{
        # map global user g ': git status -bs<ret>' -docstring 'git status'
        hook global WinSetOption filetype=git-status %{
            map window normal c ': git commit --verbose '
            map window normal l ': git log --oneline --graph<ret>'
            map window normal d ': -- %val{selections}<a-!><home> git diff '
            map window normal D ': -- %val{selections}<a-!><home> git diff --cached '
            map window normal a ': -- %val{selections}<a-!><home> git add '
            map window normal A ': -- %val{selections}<a-!><home> repl git add -p '
            map window normal r ': -- %val{selections}<a-!><home> git reset '
            map window normal R ': -- %val{selections}<a-!><home> repl git reset -p '
            map window normal o ': -- %val{selections}<a-!><home> git checkout '
        }
        hook global WinSetOption filetype=git-log %{
            map window normal d     ': %val{selections}<a-!><home> git diff '
            map window normal <ret> ': %val{selections}<a-!><home> git show '
            map window normal r     ': %val{selections}<a-!><home> git reset '
            map window normal R     ': %val{selections}<a-!><home> repl git reset -p '
            map window normal o     ': %val{selections}<a-!><home> git checkout '
        }
    } \
    "https://bitbucket.org/KJ_Duncan/kakoune-racket.kak" %{} \
    "https://github.com/h-youhei/kakoune-surround" %{} \
    "https://github.com/JJK96/kaktree" %{
        define-command kaktree--left-action %{
            evaluate-commands -save-regs "/" %{
                # Check if the current directory is open
                set-register "/" %opt{kaktree_dir_icon_open}
                try %{
                    execute-keys xs<ret>
                } catch %{
                    execute-keys <a-[>ik
                }
                kaktree--tab-action
            }
        }
        hook global WinSetOption filetype=kaktree %{
            remove-highlighter buffer/numbers
            remove-highlighter buffer/matching
            remove-highlighter buffer/wrap
            remove-highlighter buffer/show-whitespaces
            # t toggles keeping focus
            map buffer normal t ': set buffer kaktree_keep_focus %sh{[ "$kak_opt_kaktree_keep_focus" = true ] && echo false || echo true ]}<ret>'
            map buffer normal <left> ': kaktree--left-action<ret>'
            map buffer normal <right> ': kaktree--tab-action<ret>'
        }
        kaktree-enable
        set-option global kaktree_double_click_duration '0.5'
        set-option global kaktree_indentation 2
        set-option global kaktree_dir_icon_open  '▾ 📂'
        set-option global kaktree_dir_icon_close '▸ 📁'
        set-option global kaktree_file_icon      '⠀⠀📄'
        set-option global kaktree_tab_open_file true
    } \
    "https://github.com/andreyorst/fzf.kak" %{} \
    'ls ./northwave' %{}


# Overwrites colors defined in kak-lsp
colorscheme gruvbox
