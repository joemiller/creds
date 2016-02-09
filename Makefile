all: install

test:
	bats ./test

install:
	install -m 0755 -p ./creds /usr/local/bin/creds

uninstall:
	rm -f -- /usr/local/bin/creds

.PHONY: all test
