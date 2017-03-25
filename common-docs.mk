# This task requires Docker to be running. In your `circle.yml` ensure docker is
# available:

# ```
# ---
# machine:
# 	  services:
# 		    - docker
# 				``````
# ```

## Append tasks to the global tasks
test:: test-readme-toc

## doc related tasks
test-readme-toc: ## test if table of contents in README.md needs to be updated
	@if grep -q '<!-- toc -->' ./README.md; then \
		bash -c "diff -c --ignore-blank-lines --strip-trailing-cr \
					<(cat ./README.md | docker run --rm -i -v `pwd`:/src quay.io/getpantheon/markdown-toc -; echo) \
					<(cat ./README.md | awk '/<!-- toc -->/{flag=1;next}/<!-- tocstop -->/{flag=0}flag' | sed '1d;\$$d')\
				" \
		|| { echo "ERROR: README.md table of contents needs updating. Run 'make update-readme-toc', commit and push changes to your branch."; exit 1; } \
	fi

readme-toc:
	@echo "WARNING!!! The 'readme-toc' task has been renamed to 'update-readme-toc'. Please update your makefile. This task will be removed in the future."
readme-toc: update-readme-toc

update-readme-toc: ## update the Table of Contents in ./README.md (replaces <!-- toc --> tag)
	docker run --rm -v `pwd`:/src quay.io/getpantheon/markdown-toc -i /src/README.md

.PHONY:: test-readme-toc readme-toc update-readme-toc
