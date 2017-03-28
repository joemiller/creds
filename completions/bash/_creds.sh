#!/bin/bash
#
# Bash completion helpers for `creds` util: https://github.com/joemiller/creds

_creds_list_cred_stores() {
  creds list | awk '/^-/ { print $NF}'
}

_creds() {
	local cur prev creds_stores
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"

	case "$prev" in
    edit|set|unset|run)
      creds_stores=$(_creds_list_cred_stores)
      COMPREPLY=( $(compgen -W "$creds_stores" -- "$cur") )
      ;;
    list)
      COMPREPLY=()
      ;;
    import)
      _filedir
      ;;
    *)
	    COMPREPLY=( $(compgen -W "list edit import set unset run" -- "$cur") )
      ;;
	esac
}
complete -F _creds creds
