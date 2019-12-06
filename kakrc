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

# indentation
set-option global tabstop     4
set-option global indentwidth 4

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

# Movement mode (depends on case.kak)
map global user m -docstring "case based movement" ': enter-user-mode movecase<ret>'

# user mappings
map global user l -docstring 'lsp' ': enter-user-mode lsp<ret>'

## clipboard interaction
map global user p -docstring 'paste from clipboard' '!xsel -bo<ret>uU'
map global user y -docstring 'copy to clipboard' '<a-|>xsel -bi<ret>'
map global user d -docstring 'cut to clipboard' '|xsel -bi<ret>'

# format
map global user f -docstring 'format buffer' ':format<ret>'

define-command comment %{
    try comment-block catch comment-line
}

# comment lines
map global user c -docstring 'comment lines' %{_: comment<ret>}

# tabs to spaces
hook global InsertChar \t %{
    exec -draft h@
}

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
# nop %sh{ (kak-lsp1 -s $kak_session -vvv ) > /tmp/kak-lsp.log 2>&1 < /dev/null & }
# lsp-enable
hook global WinSetOption filetype=(rust|python|php|haskell|c|cpp) %{
    lsp-enable-window
    lsp-auto-hover-enable
    set global lsp_hover_anchor true
}
hook -group lsp global KakEnd .* lsp-exit

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
set-option global modelinefmt %{{Error}%sh{[ $kak_opt_lsp_diagnostic_error_count -gt 0 ] && echo "$kak_opt_lsp_diagnostic_error_count"}{StatusLineInfo} %sh{ echo $kak_opt_dbgp_indicator } {StatusLine}%val{bufname} %val{cursor_line}:%val{cursor_char_column} {{context_info}} {{mode_info}} - %val{client}@[%val{session}]}

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
plug "lenormf/kakoune-extra" load %{
    #syntastic.kak
} 
plug "alexherbo2/yank-ring.kak" %{
    map global normal <c-p> ': yank-ring<ret><c-p>'
    map global normal <c-n> ': yank-ring<ret><c-n>'
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
plug 'jjk96/kakoune-repl-bridge'
plug 'jjk96/kakoune-dbgp' %{
    map global user x -docstring 'dbgp' ': enter-user-mode dbgp<ret>'
    dbgp-enable-autojump
}
plug 'occivink/kakoune-gdb'
# plug 'occivink/kakoune-roguelight'
# plug 'danr/neptyne'

# Overwrites colors defined in kak-lsp
colorscheme gruvbox
