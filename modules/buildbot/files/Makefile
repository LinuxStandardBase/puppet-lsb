#!/usr/bin/make

# Makefile for buildbot setup on build systems.

TOPLEVEL = $(shell pwd)

bin/python:
	virtualenv $(TOPLEVEL)

bin/buildslave: bin/python
	bin/pip install buildbot-slave

bin/buildbot: bin/python
	bin/pip install buildbot

