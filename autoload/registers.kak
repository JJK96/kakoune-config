# View contents of regsters
# Original source: https://github.com/Delapouite/kakoune-registers/blob/master/registers.kak

def list-registers -docstring 'populate the *registers* buffer with the content of registers' %{
  edit! -scratch *registers*
  %sh{
    # empty scratch buffer
    echo 'exec -no-hooks \%d'

    # paste the content of each register on a separate line
    for reg in {'%','.','#','"','@','/','^','|',{a..z},{0..9}}; do
      echo "exec -no-hooks 'i${reg}<space><esc>\"${reg}po<esc>'"
    done

    # hide empty registers (lines with less than 4 chars)
    echo 'exec -no-hooks \%<a-s><a-K>.{4,}<ret>d<space>'
  }
}

# beware, it wipes the content of reg x
def info-registers -docstring 'populate an info box with the content of registers' %{
  list-registers
  exec -save-regs \% '%"xyga'
  info -title registers -- %reg{x}
  set-register x ''
}

