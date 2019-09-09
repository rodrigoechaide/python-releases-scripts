FROM python:3.7.4-alpine3.10

RUN apk add --no-cache make=4.2.1-r2 \
		 gcc=8.3.0-r0 \
		 libc-dev=0.7.1-r0

WORKDIR /inc/release-me-python/

RUN pip install setuptools==41.2.0 \
		astroid==2.2.5 \
		pylint==2.3.1 \
		isort==4.2.15 \
		flake8==3.7.8 \
		bumpversion==0.5.3

COPY . /inc/release-me-python