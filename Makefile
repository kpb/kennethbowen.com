#!/usr/bin/make
#
# TODO Move all this logic to a top level makefile for all modules.
# should build the whole site from the various modules and deploy it.


.PHONY: deploy
deploy:
	rsync -avz -e ssh src/ blackand@blackandwhitemartini.com:public_html/kennethbowen/resume

