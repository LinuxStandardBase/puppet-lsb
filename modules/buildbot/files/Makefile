#!/usr/bin/make

# Makefile for buildbot setup on build systems.

BUILDBOT_CONFIG_REPO = http://bzr.linuxfoundation.org/unofficial/buildbot-config
BUILDBOT_VERSION = 0.8.5

TOPLEVEL = $(shell pwd)

bin/python:
	virtualenv $(TOPLEVEL)

bin/buildslave: bin/python
	bin/pip install buildbot-slave==$(BUILDBOT_VERSION)

bin/buildbot: bin/python
	bin/pip install buildbot==$(BUILDBOT_VERSION)

buildbot-config:
	bzr checkout $(BUILDBOT_CONFIG_REPO)
