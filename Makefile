#!/usr/bin/make
#
# Build and deploy kennethbowen.com

# build vars
OUTPUTDIR = output

# deploy vars
DEPLOY_USER = blackand
DEPLOY_HOST = blackandwhitemartini.com

# Init the project:
# - create the 'output' dir
.PHONY: init
init:
	mkdir -p $(OUTPUTDIR)

# Clean the project:
# - delete the 'output' dir
.PHONY: clean
clean:
	rm -rf $(OUTPUTDIR)

#
# Build Targets
#

# Build the static pages for kennethbowen.com
.PHONY: static
static: init
	cp -r src/* $(OUTPUTDIR)/

# Build the 'resume' module
# - copy all files from resume/src into the output dir
.PHONY: resume
resumedir = $(OUTPUTDIR)/resume
resume: init
	mkdir -p $(resumedir)
	cp -r resume/src/* $(resumedir)

# Build everything
.PHONY: all
all: static resume

#
# Deploy Targets
#

# Deploy the resume module
.PHONY: deploy-resume
deploy-resume: resume
	rsync -avz -e ssh $(resumedir) $(DEPLOY_USER)@$(DEPLOY_HOST):public_html/kennethbowen

# Deploy for great justice
.PHONY: deploy
deploy: deploy-resume
