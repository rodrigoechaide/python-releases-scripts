# release-me-python docker image [![Build Status](http://jenkins.ascentio.com.ar/jenkins/job/asc-comp/job/release-me-python_image/badge/icon)](http://jenkins.ascentio.com.ar/jenkins/job/asc-comp/job/release-me-python_image/)

Scripts to facilitate python units and libraries releases. Now with Docker Support! Docker builded image is aimed to be used in the pipeline process of build, test and release of python units and libraries. Jenkins will use this image as a base image in order to run the pipeline into.

## What it does?
* Installers generation.
* Source Code packages generation.
* Release automation, version upgrades and tags management.

## How to use it in my unit?

### Configure
In the unit repository:
* Create a `requirements.txt` file.
* Make sure that `setup.py` file has the specified version.
* (Optional) In case of having more than one file with the version string, create a `.bumpversion.cfg` file with the following content:

```
[bumpversion]
current_version = <current-development-version>-rc1

[bumpversion:file:setup.py]
[bumpversion:file:other-archive-with-version.py]
```

### Usage

**Preferably releases have to be done from Jenkins** for that reasong a job have to be created in [python-units_seed](http://jenkins.ascentio.com.ar/jenkins/job/JobsSeeds/job/python-units_seed/).

**TODO**: Add documentation about how to create pipeline in the new Jenkins Server.

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
