FROM python:3.7.4-alpine3.10

RUN apk add --no-cache make gcc libc-dev

WORKDIR /inc/release-me-python/

RUN pip install -r setuptools==41.2.0 \
		astroid==2.2.5 \
		pylint==2.3.1 \
		isort==4.2.15 \
		flake8==3.7.8 \
		bumpversion==0.5.3

COPY . /inc/release-me-python