
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
	python setup.py bdist

TAG=--tag
UNIT_NAME=
TAG_NAME=${UNIT_NAME}-{new_version}
BUMPVERSION_DEFAULT_ARGS=${SERIALIZE} ${PARSE} --commit ${TAG} --tag-name ${TAG_NAME}
release: clean check-release-parameters update-release-version update-next-development-version push
check-release-parameters:
	@:$(call check_defined, UNIT_NAME, Unit name as it should be displayed in installers and source packages)
	@:$(call check_defined, RELEASE_VERSION, which version to RELEASE)
	@:$(call check_defined, NEXT_DEVELOPMENT_VERSION, which version to NEXT_DEVELOPMENT_VERSION)

update-release-version: requirements
	bumpversion --new-version ${RELEASE_VERSION} --commit --tag --tag-name ${TAG_NAME} minor
	python setup.py sdist
	python setup.py test

update-next-development-version: requirements
	bumpversion --current-version ${RELEASE_VERSION} --new-version ${NEXT_DEVELOPMENT_VERSION} --commit minor
	python setup.py sdist
	python setup.py test

PIP_ARGS=--trusted-host nexus.ascentio.com.ar --index http://nexus.ascentio.com.ar:8082/repository/python-public/simple
requirements: local-requirements
	test -s ${CURDIR}/requirements.txt && pip install ${PIP_ARGS} -r requirements.txt || { echo "WARN: requirements.txt does not exist"; }

MAIN_DIR=main
TESTS_DIR=tests
TEST_CMD=py.test --cov-report=xml --cov-report=html --cov ${MAIN_DIR} --junit-xml=junitreport.xml ${TESTS_DIR}
ifdef USE_NOSE
TEST_CMD=python setup.py nosetests --with-coverage --with-xunit --cover-xml --cover-html
endif
test: requirements test-requirements setuptools-requirements
	${TEST_CMD}
test-requirements:
	pip install ${PIP_ARGS} nose

# Additional Requirements
local-requirements:
	test -s ${CURDIR}/requirements-local.txt && pip install ${PIP_ARGS} -r requirements-local.txt || { echo "INFO: requirements-local.txt does not exist"; }
dist: test
	python setup.py sdist

push:
	git push origin master --tags

LAST_TAG=`git tag --sort=-committerdate | head -n 1`
package-last-tag:
	git archive --prefix ${LAST_TAG}/ -o dist/${LAST_TAG}-source.tar.gz ${LAST_TAG}
last-tag:
	@echo ${LAST_TAG}

clean:
	rm -rf dist build

.PHONY: test
