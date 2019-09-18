FROM python:3.7.4-alpine3.10 AS alpine

LABEL VERSION="1.0-alpine-snap" TARGET="alpine"

WORKDIR /inc/release-me-python/
COPY *.mk /inc/release-me-python/

WORKDIR /root/

RUN apk add --no-cache gcc=8.3.0-r0 \
		 git=2.22.0-r0 \
		 make=4.2.1-r2 \
		 libc-dev=0.7.1-r0 \
		 openssh-client=8.0_p1-r0 

# Remove cache after apk add 

RUN pip install astroid==2.2.5 \
		bumpversion==0.5.3 \
		flake8==3.7.8 \
		isort==4.2.15 \
		pylint==2.3.1 \
		rwt==3.1 \
		setuptools==41.2.0

FROM python:3.7.4-buster AS debian

LABEL VERSION="1.0-debian-snap" TARGET="debian"

WORKDIR /inc/release-me-python/
COPY *.mk /inc/release-me-python/
WORKDIR /root/

RUN apt-get -y install --no-install-recommends \
		 gcc=4:8.3.0-1 \
		 git=1:2.20.1-2 \
		 make=4.2.1-1.2  \
		 libc6-dev=2.28-10 \
		 openssh-client=1:7.9p1-10

# Remove cache after apt-get install

RUN pip install astroid==2.2.5 \
		bumpversion==0.5.3 \
		flake8==3.7.8 \
		isort==4.2.15 \
		pylint==2.3.1 \
		rwt==3.1 \
		setuptools==41.2.0
