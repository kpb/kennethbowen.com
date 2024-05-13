#!/usr/bin/make
#
# Build and deploy kennethbowen.com
#
# Use: to deploy, set the DEPLOY_USER and the DEPLOY_HOST vars.

.DEFAULT_GOAL := help

# build vars
OUTPUTDIR = site

.PHONY: init
init: ## Init the project
	@mkdir -p $(OUTPUTDIR)

.PHONY: clean
clean: ## delete the build directory
	@rm -rf $(OUTPUTDIR)

#
# Build Targets
#

.PHONY: static
static: init ## Build the static pages for kennethbowen.com
	@cp -r src/* src/.??* $(OUTPUTDIR)/

.PHONY: resume
resumedir = $(OUTPUTDIR)/resume
resume: init ## Build the resume module
	@mkdir -p $(resumedir)
	@cp -r resume/src/* $(resumedir)

.PHONY: all
all: static resume ## Build Everything

#
# Deploy Targets
#

.PHONY: check-deploy-vars
check-deploy-vars: ## Ensure deploy vars have been set
	@[ "${DEPLOY_USER}" ] || ( echo ">> DEPLOY_USER is not set"; exit 1 )
	@[ "${DEPLOY_HOST}" ] || ( echo ">> DEPLOY_HOST is not set"; exit 1 )

.PHONY: deploy-resume
deploy-resume: check-deploy-vars resume ## Build and deploy the resume module
	rsync -avz -e ssh $(resumedir) $(DEPLOY_USER)@$(DEPLOY_HOST):kennethbowen.com

.PHONY: deploy
deploy: check-deploy-vars clean all ## Build and deploy all of kennethbowen.com
	rsync -avz -e ssh $(OUTPUTDIR)/ $(DEPLOY_USER)@$(DEPLOY_HOST):kennethbowen.com

.PHONY: try
try-ruby: all ## Run the site in a Ruby webserver
	ruby -run -ehttpd ./site -p8000

.PHONY: try
try-py: all ## Run the site in a Python 3 webserver
	python3 -m http.server --directory ./site 8000

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-19s\033[0m %s\n", $$1, $$2}'
