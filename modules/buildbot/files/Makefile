#!/usr/bin/make

# Makefile for buildbot setup on build systems.

BUILDBOT_CONFIG_REPO = http://bzr.linuxfoundation.org/unofficial/buildbot-config
TOPLEVEL = $(shell pwd)

bin/python:
	virtualenv $(TOPLEVEL)

bin/buildslave: bin/python
	bin/pip install buildbot-slave

bin/buildbot: bin/python
	bin/pip install buildbot

buildbot-config:
	bzr checkout $(BUILDBOT_CONFIG_REPO)
