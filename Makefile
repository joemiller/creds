all: install

test:
	bats ./test

install:
	install -m 0755 -p ./creds /usr/local/bin/creds

uninstall:
	rm -f -- /usr/local/bin/creds

circle_deps:
	bash test/circle_deps.sh

.PHONY: all test
