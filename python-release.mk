# .bumpversion.cfg example
# [bumpversion]
# current_version = 3.2.3
# commit = True
# tag = True
# tag_name = unit_name-v{new_version}
# parse = (?P<major>\d+)\.(?P<minor>\d+)\.(?P<patch>\d+)(\-rc(?P<release>[a-z]+))?
# serialize =
#       {major}.{minor}.{patch}-rc{release}
#       {major}.{minor}.{patch}

# [bumpversion:file:path/to/version.py]

# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Params:
#   1. Variable name(s) to test.
#   2. (optional) Error message to print.
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

SERIALIZE=--serialize '{major}.{minor}.{patch}-rc{release}' --serialize '{major}.{minor}.{patch}'
PARSE=--parse '(?P<major>\d+)\.(?P<minor>\d+)\.(?P<patch>\d+)(\-rc(?P<release>[a-z]+))?'
VERSION=
UNIT_NAME=
TAG_NAME=${UNIT_NAME}-{new_version}

# Check that there are no uncommitted changes in the sources.
check-repo:
	@git diff-index --quiet HEAD -- || echo "There are uncommited changes in repo"; exit 1;

# Change the version to a new version using bumpversion.
TAG=--tag
BUMPVERSION_DEFAULT_ARGS=${SERIALIZE} ${PARSE} --commit ${TAG} --tag-name ${TAG_NAME}
BUMPVERSION_TEST_ARGS=--verbose --allow-dirty --dry-run
upgrade-version: check-variables
	bumpversion ${BUMPVERSION_DEFAULT_ARGS} ${TAG} ${VERSION}

test-upgrade-version: check-variables
	bumpversion ${BUMPVERSION_DEFAULT_ARGS} ${BUMPVERSION_TEST_ARGS} ${VERSION}
check-variables:
	@:$(call check_defined, UNIT_NAME, Unit name as it should be displayed in installers and source packages)
	@:$(call check_defined, VERSION, which version to release (major, minor, patch))

# Run the tests.
requirements:
	pip install requirements.txt
test:
	python setup.py test

# Build the code.
dist:
	python setup.py sdist

LAST_TAG=`git tag --sort=-committerdate | head -n 1`
package-last-tag: check-variables
	git archive --prefix ${LAST_TAG}/ -o dist/${LAST_TAG}-source.tar.gz ${LAST_TAG}
last-tag:
	@echo ${LAST_TAG}

release: test-upgrade-version upgrade-version test dist

clean:
	rm -rf dist build

.PHONY: dist
