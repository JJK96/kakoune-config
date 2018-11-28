define-command -params .. shell -docstring %(shell [<switch>]… [<command>]…: Execute shell command

Switches:
  -export <variable>: Export variable) %{ nop %sh{
  # Ensure Kakoune sets these variables by making them appear in the source:
  # – kak_session
  # – kak_client
  # – kak_buffile
  while [ "$1" ]; do
    case $1 in
      -export)
        export="$export $2"
        shift
      ;;
      *)
        break
      ;;
    esac
    shift
  done
  for variable in $export; do
    key=$(echo kak_$variable | tr [:lower:] [:upper:])
    value=kak_$variable
    eval export $key='$'$value
  done
  ("$@") < /dev/null > /dev/null 2>&1 &
}}
