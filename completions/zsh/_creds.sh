#compdef creds

# Zsh completion helpers for `creds` util: https://github.com/joemiller/creds

local curcontext="$curcontext" state line ret=1

_creds_list_cred_stores() {
  creds list | awk '/^-/ { print $NF}'
}

_arguments -C -A "-v" -A "--version" \
	'(- 1 *)'{-v,--version}'[display version information]' \
	'1: :->cmds' \
	'*:: :->args' && ret=0

case $state in
	cmds)
		_values "creds command" \
			"list[List available credential stores]" \
      "edit[Edit a credential store]" \
      "import[Import an existing file into a new credential store]" \
      "set[Display commands to set credentials from a credential store]" \
      "unset[Display commands to unset credentials from a credential store]"
		ret=0
		;;
	args)
		case $line[1] in
			help)
				_values 'list' 'edit' 'import' 'set' 'unset' && ret=0
				;;
      edit|set|unset)
        _values "available cred stores" $(_creds_list_cred_stores) && ret=0
        ;;
      list)
        ret=0
        ;;
			import)
				_files && ret=0
				;;
		esac
		;;
esac

return ret

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et
