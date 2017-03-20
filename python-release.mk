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

# Check that there are no uncommitted changes in the sources.
check-repo:
	git diff-index --quiet HEAD -- || echo "There are uncommited chenges in repo"; exit 1;

# Change the version to a new version using bumpversion.
VERSION="patch"
upgrade-version:
	bumpversion ${VERSION}

test-upgrade-version:
	bumpversion ${VERSION} --verbose --allow-dirty --dry-run

# Run the tests.
test:
	python setup.py test

# Build the code.
dist: check-repo
	python setup.py sdist

all: check-repo test test-upgrade-version dist
