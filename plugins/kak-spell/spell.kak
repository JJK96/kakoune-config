declare-option str spell_lang

declare-option -hidden str spell_source %sh{echo "${kak_source%/*}"}
declare-option str spell_cmd "python %opt{spell_source}/cli.py"

# notes
#   we re-use the existing lint.kak script to display and navigate errors
#   we use `write` to trigger a spell check automatically

define-command spell \
  -params 1 \
  -docstring %{spell [<language>]: enable spell checking for the current buffer %} \
  %{
    evaluate-commands %sh{
      printf "set buffer spell_lang %s" $1
    }
    # need a separate evaluate-commands block because we just set the option :)
    evaluate-commands %sh{
      printf "set buffer lintcmd \"$kak_opt_spell_cmd --lang $kak_opt_spell_lang check\""
    }
    lint-enable
    write
  }

define-command spell-clear -docstring "disable spell checking for the current buffer" \
  %{
     unset-option buffer lintcmd
     lint-disable
   }

define-command spell-next -docstring "go to the next spelling error" %{
  lint-next-message
  execute-keys e
}


define-command spell-add -docstring "add the selection to the user dict" %{ \
  evaluate-commands %sh{
    if [ -z "${kak_opt_spell_lang}" ]; then
      printf %s\\n 'echo -markup {Error}The `spell_lang` option is not set'
      exit 1
    fi
  }
  nop %sh{ $kak_opt_spell_cmd --lang $kak_opt_spell_lang add $kak_selection }
  write
}

define-command spell-remove -docstring "remove the selection from the user dict" %{ \
  evaluate-commands %sh{
    if [ -z "${kak_opt_spell_lang}" ]; then
      printf %s\\n 'echo -markup {Error}The `spell_lang` option is not set'
      exit 1
    fi
  }
  nop %sh{ $kak_opt_spell_cmd --lang $kak_opt_spell_lang remove $kak_selection }
  write
}

define-command spell-replace -docstring "replace the selection with a suggestion " %{ \
  evaluate-commands %sh{
    if [ -z "${kak_opt_spell_lang}" ]; then
      printf %s\\n 'echo -markup {Error}The `spell_lang` option is not set'
      exit 1
    fi
  }

  evaluate-commands %sh{ $kak_opt_spell_cmd --lang $kak_opt_spell_lang replace $kak_selection --kakoune }
}
