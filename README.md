# release-me-python docker image [![Build Status](http://jenkins.ascentio.com.ar/jenkins/job/asc-comp/job/release-me-python_image/badge/icon)](http://jenkins.ascentio.com.ar/jenkins/job/asc-comp/job/release-me-python_image/)

# How to build?

`make build-image`: It will create **asc-comp/release-me-python** image

You can optimize build times using an http cache (1) and executing:

`make build-image HTTP_PROXY=http://172.17.0.1:3128 HTTPS_PROXY=http://172.17.0.1:3128`
or just
`make build-image-with-local-cache`

## Use local base images

Instead of pulling images you could build images using existing base images with:
`make build-image-locally` and `make build-image-locally-with-local-cache`

## Lint Dockerfile

`make lint-image` will check Dockerfile format


### Notes

1: You can spin up a local http cache with [asc-devkit](https://gitlab.ascentio.com.ar/DEV/asc-devkit) and **docker start-build-cache** command.

# References

* https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository
* https://mesosphere.com/blog/mesosphere-package-repositories/
* https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/
* https://blog.docker.com/2013/09/docker-can-now-run-within-docker
