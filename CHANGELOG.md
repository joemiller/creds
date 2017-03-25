## 0.0.4 (March 25, 2017)

  * `creds set` output now prefixes each line with a single whitespace in order
    to prevent sensitive data being stored in shell history. This assumes
    the `HISTCONTROL` option of the shell is set to `ignorespace` which is the
    default in most shells (I think).
  * Added table of contents to README and some new make tasks to help automate
    manaegement of the TOC.
  * Adopted google shell style guide.

## 0.0.3 (February 18, 2016)

  * Added bash and zsh completion helpers

## 0.0.2 (October 5, 2015)

IMPROVEMENTS:

  * less verbose output in `set` and `unset` commands

## 0.0.1 (2016-02-08)

  * initial release
