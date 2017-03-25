include common-docs.mk

all: install

test:: test_static test_integration  ## run all test suites

test_static: ## run shellcheck static analysis tests
	shellcheck ./creds

test_integration: ## run bats integration tests
	bats ./test

install: ## install creds
	install -m 0755 -p ./creds /usr/local/bin/creds

uninstall: ## uninstall creds
	rm -f -- /usr/local/bin/creds

circle_deps: ## install dependencies on circle-ci
	bash test/circle_deps.sh

help: ## print list of tasks and descriptions
	@grep --no-filename -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?##"}; { printf "\033[36m%-30s\033[0m %s \n", $$1, $$2}'

.DEFAULT_GOAL := help

.PHONY:: all test help
