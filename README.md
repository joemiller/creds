creds
=====

Simple encrypted credential file management with GPG.

Rationale
---------

I have a lot of different sensitive environment variables to juggle. API keys,
tokens, usernames, passwords, etc. I had been using simple shell scripts to
set environment variables when needed, eg:

```
$ cat ~/Dropbox/creds/aws-work.sh
AWS_ACCESS_KEY_ID=foo
AWS_SECRET_ACCESS_KEY=bar

$ source ~/Dropbox/creds/aws-work.sh
$ echo $AWS_ACCESS_KEY_ID
foo
$ s3cmd ...
```

But I don't like storing these in plaintext.

Thus, how about a simple way to encrypt/decrypt these as needed with GPG?

Requirements
------------

- bash >= 3.2
- gpg (tested with 2.0.x but might work with 1.4.x)

Tested on Mac OSX 10.11 with `gpg2` installed from homebrew, but should work
on most platforms with the above requirements.

Install
-------

Clone this repo from github, run `make install` to copy `creds` to
`/usr/local/bin`.

Or, install `creds` to somewhere in your `$PATH`.

Or, curl install!

```
$ curl https://raw.githubusercontent.com/joemiller/creds/master/creds >./creds
$ chmod +x ./creds
```

If you're on OSX you may need to install GPG and create a keypair.  You have
a few options:

- Homebrew: `brew install gpg2 gpg-agent`
- Install GPG Suite from https://gpgtools.org/

Uninstall
---------

Run `make uninstall`

Usage
-----

```
$ creds -h
usage: creds [-h|--help] [-v|--version] <subcommand> [arguments]

Simple encrypted credential file management with GPG.

The most commonly used subcommands are:

  list                  list available credential stores
  edit                  edit a credential store
  import                import an existing file into a new credential store
  set                   display commands to set credentials from a credential store
  unset                 display commands to unset credentials from a credential store
```

### Configuration

`creds` reads configuration from `~/.credsrc` file, eg:

```
CREDS_DIR="$HOME/Dropbox/creds"
```

Required variables:

- `CREDS_DIR`: A directory where encrypted credentials files will be stored.
- `GPG_KEY`: A GPG key ID in your keychain. Use `gpg -K` to list keys.

Optional variables:

- `GPG_BIN`: Path to GPG bin to use. If not set, `creds` will look for `gpg2`
   and `gpg` in the path, preferring `gpg2` if found.

### Creating a new credential store / Editing existing credential store

The `edit` command will create a new credential store if one does not exist yet.

The format of credential stores is single line `KEY=val` environment variable
style lines. All other lines will be ignored when using the `set` and `unset`
commands.

```
$ creds edit aws-work

< .. $EDITOR launches .. >
FOO=bar
```

### Listing credential stores

```
$ creds list
Credential storage dir: /Users/joe/Dropbox/creds
- aws-work
- misc.txt
- digitalocean
```

### Setting/Loading

Use the `set` command to print the contents of a credential store.

Usually you will wrap this with `eval` to set the credentials in your shell's
environment.

```
$ creds set aws-work
FOO=bar

$ eval $(creds set aws-work)

$ echo $FOO
bar
```

### Unsetting

Use the `unset` command to unset the credentials. This should also be used
with `eval`.

```
$ echo $FOO
bar

$ creds unset aws-work
unset FOO

$ eval $(creds unset aws-work)
$ echo $FOO
$
```

### Importing an existing plaintext file

```
$ cat ./circleci.keys
CIRCLE_TOKEN=foo

$ creds import ./circleci.keys
Encrypting './circleci.keys' to '/Users/joe/Dropbox/creds/circleci.keys.gpg'
```

Developing
----------

Run `make test` to run the test suite. You will need `bats` installed.

TODO
----

- the output may be too verbose, such as the two header lines in set and unset
- maybe make it work with the `keybase` commands too? but don't introduce a
  dependency on keybase.
- Rewrite in go, optionally using gpg library? Unlikely as this is intended to
  be a simple tool and already has very few external dependencies (only bash
  3.2+ and gpg)

Author
------

joe miller, 2016
