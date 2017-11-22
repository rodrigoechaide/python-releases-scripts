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

RELEASE_VERSION=
NEXT_DEVELOPMENT_VERSION=
package:
	test -e setup.py && python setup.py bdist || { echo "WARN: no setup.py, no bdist"; }


TAG=--tag
BUMPVERSION_DEFAULT_ARGS=${SERIALIZE} ${PARSE} --commit ${TAG}
release: clean check-release-parameters update-release-version update-next-development-version push

pre-release: clean check-release-parameters update-release-version
post-release: update-next-development-version push package-last-tag

check-release-parameters:
	@:$(call check_defined, RELEASE_VERSION, which version to RELEASE)
	@:$(call check_defined, NEXT_DEVELOPMENT_VERSION, which version to NEXT_DEVELOPMENT_VERSION)

update-release-version: requirements bump-release-version
	test -e setup.py && python setup.py sdist || { echo "WARN: no setup.py, no sdist"; }
	test -e setup.py && python setup.py test || { echo "WARN: no setup.py, no test"; }
bump-release-version:
	bumpversion --new-version ${RELEASE_VERSION} --commit --tag minor

bump-next-development-version:
	bumpversion --current-version ${RELEASE_VERSION} --new-version ${NEXT_DEVELOPMENT_VERSION} --commit minor
update-next-development-version: requirements bump-next-development-version
	test -e setup.py && python setup.py sdist || { echo "WARN: no setup.py, no sdist"; }
	test -e setup.py && python setup.py test || { echo "WARN: no setup.py, no test"; }

PYPI_INDEX=http://nexus.ascentio.com.ar/nexus/repository/python-public/simple
PIP_ARGS=--trusted-host nexus.ascentio.com.ar --index ${PYPI_INDEX}
requirements: setuptools-requirements local-requirements
	test -s ${CURDIR}/requirements.txt && pip install ${PIP_ARGS} -r requirements.txt || { echo "WARN: requirements.txt does not exist"; }
setuptools-requirements:
	test -s setup.py && pip install ${PIP_ARGS} -e '.[local]' || { echo "WARN: setup.py does not exist"; }

MAIN_DIR=main
TESTS_DIR=tests
TEST_CMD=python setup.py test
ifdef USE_NOSE
TEST_CMD=python setup.py nosetests --with-coverage --with-xunit --cover-xml --cover-html
endif
test: requirements setuptools-requirements
	test -e setup.py && ${TEST_CMD} || { echo "WARN: no setup.py, no dist"; }

pylint:
	pylint --rcfile=setup.cfg ${MAIN_DIR} > pylint.out || { echo "WARN: PyLint exit code different to 0: $?"; }

flake8:
	flake8 --config=setup.cfg ${MAIN_DIR} > flake8.out || { echo "WARN: Flake8 exit code different to 0: $?"; }

static-analysis: pylint flake8

local-requirements:
	test -s ${CURDIR}/requirements-local.txt && pip install --exists-action=w ${PIP_ARGS} -r requirements-local.txt || { echo "INFO: requirements-local.txt does not exist"; }
dist: test
	test -e setup.py && python setup.py sdist bdist_wheel || { echo "WARN: no setup.py, no test"; }

BRANCH=master
push:
	git push origin ${BRANCH} --tags

install-rwt:
	pip install rwt==3.1

# REPO: snapshots|releases
REPO=snapshots
upload-to-nexus: install-rwt dist
	rwt -q twine==1.9.1 -- -m twine upload -r ${REPO} dist/*

LAST_TAG=`git tag --sort=-committerdate | head -n 1`
package-last-tag:
	mkdir -p dist
	git archive --prefix ${LAST_TAG}/ -o dist/${LAST_TAG}-source.tar.gz ${LAST_TAG}
last-tag:
	@echo ${LAST_TAG}

clean:
	rm -rf dist build

.PHONY: test
