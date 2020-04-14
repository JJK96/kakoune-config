# relative line numbers
add-highlighter global/ number-lines -relative -hlcursor
add-highlighter global/ wrap

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

## clipboard interaction
map global user p -docstring 'paste from clipboard' '!xsel -bo<ret>uU'
map global user y -docstring 'copy to clipboard' '<a-|>xsel -bi<ret>'
map global user d -docstring 'cut to clipboard' '|xsel -bi<ret>'

# format
# map global user f -docstring 'format buffer' ':format<ret>'

define-command comment %{
    try %{
        execute-keys _
        comment-block
    } catch comment-line
}

# comment lines
map global user c -docstring 'comment lines' %{: comment<ret>}

# search with c tags
map global goto s -docstring 'search ctags' %{<esc><a-i>w: ctags-search<ret>}

# # Use termite
require-module x11
set global termcmd "termite -e"

# Terminal, used by ide wrapper
define-command -hidden _terminal -params .. %{
  shell \
    -export session \
    -export client \
    %sh(echo $TERMINAL) %arg(@) \
    %sh(test $# = 0 &&
      echo $SHELL
    )
}

# this has to be executed first
require-module x11-repl
alias global repl _terminal

# Delete buffer and quit
map global normal <c-q> ": db;q<ret>"

# Open file in new window
define-command open-in-new-window -params .. -file-completion %{ new edit-or-dir "%arg{@}"}
alias global e open-in-new-window

# file types
hook global BufCreate .*\.xsd %{ set buffer filetype xml }

# kakoune language server

# Depends on https://github.com/ul/kak-lsp
eval %sh{kak-lsp --kakoune -s $kak_session }
# Debug output
#nop %sh{ (kak-lsp1 -s $kak_session -vvv ) > /tmp/kak-lsp.log 2>&1 < /dev/null & }
# lsp-enable
hook global WinSetOption filetype=(rust|python|php|haskell|c|cpp) %{
    lsp-enable-window
    lsp-auto-hover-enable
    set global lsp_hover_anchor true
    # set global lsp_snippet_callback snippets-insert
}

#spell
# map global user s -docstring 'spell replace' :spell-replace<ret>
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

# Disable sql highlighting
set global disabled_hooks sql-highlight

# Plugins

source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "andreyorst/plug.kak" noload
plug "occivink/kakoune-phantom-selection" %{
    declare-user-mode phantom-selection
    map global user h -docstring "Phantom selections" ": enter-user-mode phantom-selection<ret>"
    map global phantom-selection n -docstring "Next" ": phantom-selection-iterate-next<ret>"
    map global phantom-selection p -docstring "Previous" ": phantom-selection-iterate-prev<ret>"
    map global phantom-selection c -docstring "Clear" ": phantom-selection-select-all; phantom-selection-clear<ret>"
    map global phantom-selection a -docstring "Add" ": phantom-selection-add-selection<ret>"
}
# plug "alexherbo2/phantom.kak" %{
#     hook global WinCreate .* %{
#         phantom-enable -with-maps
#     }
# }
plug "occivink/kakoune-snippets" %{
    set-option global snippets_auto_expand false
    declare-user-mode snippets
    map global user s -docstring "Snippets" ": enter-user-mode snippets<ret>"
    map global snippets n -docstring "Select next placeholder" ": snippets-select-next-placeholders<ret>"
    map global snippets s -docstring "Snippet" ": snippets "
    map global snippets i -docstring "Info" ": snippets-info<ret>"
    map global insert <a-e> "<esc>: try snippets-select-next-placeholders catch phantom-selection-iterate-next<ret>i"
    add-highlighter global/ ranges snippets_placeholders 
    set-option global snippets_directories "%opt{plug_install_dir}/kakoune-snippet-collection/snippets"
    source "%val{config}/snippets.kak"
}
plug "andreyorst/kakoune-snippet-collection"

plug "occivink/kakoune-sudo-write"
plug "jjk96/kakoune-fireplace"
# plug "lenormf/kakoune-extra" load %{
#     #syntastic.kak
# }
plug "alexherbo2/prelude.kak" %{
    plug "alexherbo2/connect.kak" %{
        plug "alexherbo2/yank-ring.kak" %{
            map global user Y ': yank-ring<ret>'
        }
    }
}
plug "Delapouite/kakoune-buffers" %{
    map global user b ': enter-user-mode -lock buffers<ret>'   -docstring 'buffers (lock)…'
}
plug "ul/kak-tree" %{
    declare-user-mode tree
    map global tree u ': tree-select-parent-node<ret>' -docstring 'parent'
    map global tree n ': tree-select-next-node<ret>' -docstring 'next'
    map global tree p ': tree-select-previous-node<ret>' -docstring 'previous'
    map global tree c ': tree-select-children<ret>' -docstring 'children'
    map global tree f ': tree-select-first-child<ret>' -docstring 'first child'
    map global tree t ': tree-node-sexp<ret>' -docstring 'show syntax tree'
    map global tree . ': enter-user-mode -lock tree<ret>' -docstring 'lock'
    map global user t ': enter-user-mode tree<ret>' -docstring 'tree-sitter'
}
plug 'delapouite/kakoune-cd' %{
    # Suggested aliases
    alias global cdb change-directory-current-buffer
    alias global cdr change-directory-project-root
    alias global ecd edit-current-buffer-directory
    alias global pwd print-working-directory
}
plug 'Delapouite/kakoune-mirror' %{
    map global user o -docstring 'mirror' ': enter-user-mode mirror<ret>'
    map global mirror * -docstring 'stars (markdown bold)' 'i**<esc>a**<esc>'
    map global mirror $ -docstring '$ (latex math)' 'i$<esc>a$<esc>'
    map global mirror . ': enter-user-mode -lock mirror<ret>'
}
plug 'alexherbo2/split-object.kak' %{
    map global normal <a-L> ': enter-user-mode split-object<ret>'
}
plug 'eraserhd/kak-ansi'
plug 'jjk96/kakoune-emmet' %{
    hook global WinSetOption filetype=(xml|html) %{
        emmet-enable-autocomplete
    }
}
plug 'jjk96/kakoune-python-bridge' %{
    # calculate
    map global normal = ': python-bridge-send<ret>R'
    map global normal <backspace> ': python-bridge-send<ret>'
    python-bridge-send %{
from math import *
    }
}
plug 'jjk96/kakoune-repl-bridge' %{
    hook global BufSetOption filetype=haskell %{
        map buffer normal = ': repl-bridge haskell send<ret>R'
        map buffer normal <backspace> ': repl-bridge haskell send<ret>'
    }
}
plug 'jjk96/kakoune-dbgp' %{
    hook global WinSetOption filetype=php %{
        dbgp-enable-autojump
        map global user x -docstring 'debugger' ': enter-user-mode dbgp<ret>'
    }
}
# plug 'jjk96/kakoune-debug' %{
#     hook global WinSetOption filetype=php %{
#         set global debugger dbgp
#         debugger-enable-autojump
#     }
#     hook global WinSetOption filetype=(c|cpp) %{
#         set global debugger gdb
#         debugger-enable-autojump
#     }
#     map global user x -docstring 'debugger' ': enter-user-mode debugger<ret>'
# }
plug 'occivink/kakoune-gdb'
plug "eraserhd/parinfer-rust" do %{
        cargo install --force --path .
} config %{
    hook global WinSetOption filetype=(clojure|lisp|scheme|racket) %{
        parinfer-enable-window -smart
    }
}
plug "kakoune-repl-send" %{
    hook global BufSetOption filetype=scheme %{
        map buffer normal <backspace> ': repl-send<ret>'
        set buffer repl_send_command "stdbuf -o0 chicken-csi"
        set buffer repl_send_exit_command "(exit)"
    }
}
plug "fsub/kakoune-mark" domain gitlab %{
    declare-user-mode mark
    map global mark -docstring "mark word" m ": mark-word<ret>"
    map global mark -docstring "clear marks" c ": mark-clear<ret>"
    map global user -docstring "mark" m ": enter-user-mode mark<ret>"
}
plug "andreyorst/tagbar.kak" defer "tagbar" %{
    set-option global tagbar_sort false
    set-option global tagbar_size 40
    set-option global tagbar_display_anon false
    set-option global tagbar_display_anon true
} config %{
    # if you have wrap highlighter enamled in you configuration
    # files it's better to turn it off for tagbar, using this hook:
    hook global WinSetOption filetype=tagbar %{
        remove-highlighter window/wrap
        # you can also disable rendering whitespaces here, line numbers, and
        # matching characters
    }
}
plug 'delapouite/kakoune-palette'
plug 'TeddyDD/kakoune-edit-or-dir'
plug 'jjk96/kakoune-rainbow'
plug 'occivink/kakoune-find'
# plug 'kak-spell' %{
#     set-option global spell_lang en
#     declare-user-mode spell
#     map global spell -docstring "Enable" e ': spell %opt{spell_lang}<ret>'
#     map global spell -docstring "Lint" u ': lint-buffer<ret>'
#     map global spell -docstring "Next" n ': lint-next-message<ret>'
#     map global spell -docstring "Replace" r ': spell-replace<ret>'
#     map global spell -docstring "Clear" c ': spell-clear<ret>'
# }
plug "listentolist/kakoune-table" domain "gitlab.com" config %{
}
plug "andreyorst/fzf.kak" domain "gitlab.com" config %{
    map global user f -docstring "fzf" ': fzf-mode<ret>'
}
plug chambln/kakoune-kit config %{
    map global user g ': git status -bs<ret>' -docstring 'git status'
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
}

# plug 'occivink/kakoune-roguelight'
# plug 'danr/neptyne'

# Overwrites colors defined in kak-lsp
colorscheme gruvbox
