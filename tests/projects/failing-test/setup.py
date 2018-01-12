# Copyright (c) 2018 Ascentio Technologies S.A. All rights reserved.
#
# This program is confidential and proprietary to Ascentio Technologies S.A.,
# and may not be copied, reproduced, modified, disclosed to
# others, published or used, in whole or in part, without the
# express prior written permission of Ascentio Technologies S.A.

import io
import os
import sys
from pip.req import parse_requirements
from setuptools import setup, find_packages

__author__ = "someone"
__copyright__ = "Copyright (c) 2018 Ascentio Technologies S.A."


APP_NAME = "dummy"
APP_DESCRIPTION = ""

HERE = os.path.abspath(os.path.dirname(__file__))

setup(
    name=APP_NAME,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    description=APP_DESCRIPTION,
    long_description="README.md",
    url="https://gitlab.ascentio.com.ar/PlaMEDMA/asc-waftools",
    license="Copyright (c) 2018 Ascentio Technologies S.A.",
    author="Franco Riberi",
    author_email="friberi@ascentio.com.ar",
    keywords=['test'],
    setup_requires=["pytest-runner", "flake8"]
        if 'test' in sys.argv else list(),
    tests_require=['pytest==3.2.2', 'pytest-cov==2.5.1'],
    install_requires=[],
    classifiers=[
        'Development Status :: 1 - Beta',
        'Programming Language :: Python :: 2.7',
        'Environment :: Console',
        'Topic :: Software Development :: Libraries :: Python Modules',
        "Topic :: Software Development :: Build Tools"
    ]
)
