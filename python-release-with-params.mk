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
package: setup.py
	python setup.py bdist


TAG=--tag
BUMPVERSION_DEFAULT_ARGS=${SERIALIZE} ${PARSE} --commit ${TAG}
release: clean check-release-parameters update-release-version update-next-development-version push

pre-release: clean check-release-parameters update-release-version
post-release: update-next-development-version push package-last-tag

check-release-parameters:
	@:$(call check_defined, RELEASE_VERSION, which version to RELEASE)
	@:$(call check_defined, NEXT_DEVELOPMENT_VERSION, which version to NEXT_DEVELOPMENT_VERSION)

update-release-version: setup.py requirements bump-release-version
	python setup.py sdist
	python setup.py test
bump-release-version:
	bumpversion --new-version ${RELEASE_VERSION} --commit --tag minor

bump-next-development-version:
	bumpversion --current-version ${RELEASE_VERSION} --new-version ${NEXT_DEVELOPMENT_VERSION} --commit minor
update-next-development-version: requirements setup.py bump-next-development-version
	python setup.py sdist
	python setup.py test

PYPI_INDEX=http://nexus.ascentio.com.ar/nexus/repository/python-public/simple
PIP_ARGS=--trusted-host nexus.ascentio.com.ar --index ${PYPI_INDEX}
requirements: setuptools-requirements local-requirements
	test -s ${CURDIR}/requirements.txt && pip install ${PIP_ARGS} -r requirements.txt --user || { echo "WARN: requirements.txt does not exist"; }
setuptools-requirements: setup.py
	pip install ${PIP_ARGS} -e '.[local]' --user

MAIN_DIR=main
TESTS_DIR=tests
TEST_CMD=python setup.py test
ifdef USE_NOSE
TEST_CMD=python setup.py nosetests --with-coverage --with-xunit --cover-xml --cover-html
endif
test: requirements setup.py setuptools-requirements
	${TEST_CMD}

setup.py:
	$(error setup.py does not exist!)

pylint:
	pylint --rcfile=setup.cfg ${MAIN_DIR} > pylint.out || { echo "WARN: PyLint exit code different to 0: $?"; }

flake8:
	flake8 --config=setup.cfg ${MAIN_DIR} > flake8.out || { echo "WARN: Flake8 exit code different to 0: $?"; }

static-analysis: pylint flake8

local-requirements:
	test -s ${CURDIR}/requirements-local.txt && pip install --exists-action=w ${PIP_ARGS} -r requirements-local.txt --user || { echo "INFO: requirements-local.txt does not exist"; }
dist: setup.py test sdist bdist_wheel
sdist: setup.py test
	python setup.py sdist
bdist_wheel: setup.py test
	# Some units require sudo permissions to created bdist, while we fix that, we just warn.
	python setup.py bdist_wheel || echo 'WARN: could not create bdist_wheel'

BRANCH=master
push:
	git push origin ${BRANCH} --tags

install-rwt:
	pip install rwt==3.1 --user

# REPO: snapshots|releases
REPO=snapshots
# ARTIFACT_REGISTRY__CREDENTIALS_USR, ARTIFACT_REGISTRY_CREDENTIALS_PSW and ARTIFACT_REGISTRY_URL must be configured inside the system runing the build as ENV VARS
upload-to-nexus: install-rwt dist
	rwt -q twine==1.9.1 -- -m twine upload --repository-url ${ARTIFACT_REGISTRY_URL} -u ${ARTIFACT_REGISTRY_CREDENTIALS_USR} -p ${ARTIFACT_REGISTRY_CREDENTIALS_PSW} dist/*

LAST_TAG=`git tag --sort=-committerdate | head -n 1`
package-last-tag:
	mkdir -p dist
	git archive --prefix ${LAST_TAG}/ -o dist/${LAST_TAG}-source.tar.gz ${LAST_TAG}
last-tag:
	@echo ${LAST_TAG}

clean:
	rm -rf dist build

.PHONY: test
