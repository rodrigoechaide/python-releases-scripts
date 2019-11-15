# release-me-python

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
