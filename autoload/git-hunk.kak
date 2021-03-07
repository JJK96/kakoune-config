define-command git-hunk-stage %{
	git-hunk-apply-impl "--cached"
} -docstring "Stage hunk at cursor"
define-command git-hunk-unstage %{
	git-hunk-apply-impl "--cached --reverse"
} -docstring "Unstage hunk at cursor"
define-command git-hunk-apply %{
	git-hunk-apply-impl ""
} -docstring "Apply hunk at cursor"
define-command git-hunk-revert %{
	git-hunk-apply-impl "--reverse"
} -docstring "Revert hunk at cursor"

define-command -hidden git-hunk-apply-impl -params 1 %{ evaluate-commands -draft -save-regs ah| %{
	set-register a %arg{1}
	# Save the diff header to register h.
	execute-keys -draft '<space><a-/>^diff.*?\n(?=@@)<ret><a-x>"hy'
	# Select the current hunk.
	execute-keys ?^@@|^diff|^$<ret>K<a-x><semicolon><a-?>^@@<ret><a-x>
	set-register | %{
		( printf %s "$kak_reg_h"; cat ) |
		git apply $kak_reg_a --whitespace=nowarn -
	}
	execute-keys |<ret>
}}
