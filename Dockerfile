FROM python:3.7.4-alpine3.10

RUN apk add --no-cache gcc=8.3.0-r0 \
		 git=2.22.0-r0 \
		 make=4.2.1-r2 \
		 libc-dev=0.7.1-r0

WORKDIR /inc/release-me-python/

RUN pip install setuptools==41.2.0 \
		astroid==2.2.5 \
		pylint==2.3.1 \
		isort==4.2.15 \
		flake8==3.7.8 \
		bumpversion==0.5.3 \
		rwt==3.1

COPY *.mk /inc/release-me-python/