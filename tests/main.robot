*** Settings ***
Library  Collections
Library  String
Library  OperatingSystem

*** Variables ***
${MAKEFILE}  ${CURDIR}/../python-release-with-params.mk
${PROJECTS_DIR}  ${CURDIR}/projects


*** Keywords ***
Execute Make
    [Arguments]  ${project}  ${rule}
    [Return]  ${rc}  ${output}
    ${rc}  ${output}=  Run and Return RC and Output  make -C ${PROJECTS_DIR}/${project} -f ${MAKEFILE} ${rule}

*** Test Cases ***
Should fail if test does not succeed
    ${rc}  ${output}=  Execute Make  failing-test  test

    Log  ${output}
    Should Not Be Equal As Integers  ${rc}  0
    Should Contain Any  ${output}  ERROR: file not found: test
    Should Not Contain Any  ${output}  setup.py does not exist

Should succeed if package
    ${rc}  ${output}=  Execute Make  failing-test  package

    Log  ${output}
    Should Be Equal As Integers  ${rc}  0
    Should Contain Any  ${output}  Creating tar archive
    Should Not Contain Any  ${output}  setup.py does not exist

Should fail with test if there is no setup.py
    ${rc}  ${output}=  Execute Make  no-setup-py  test

    Log  ${output}
    Should Not Be Equal As Integers  ${rc}  0
    Should Contain Any  ${output}  setup.py does not exist

Should fail with package if there is no setup.py
    ${rc}  ${output}=  Execute Make  no-setup-py  package

    Log  ${output}
    Should Not Be Equal As Integers  ${rc}  0
    Should Contain Any  ${output}  setup.py does not exist
