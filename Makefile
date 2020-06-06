lint:
	# See local hadolint install instructions:   https://github.com/hadolint/hadolint
	# This is linter for Dockerfiles
	hadolint Dockerfile

	# Lint the html code unser my_site
	tidy -q -e my_site/*.html


all: lint
