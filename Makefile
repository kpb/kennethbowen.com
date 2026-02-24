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

.PHONY: build
build: init ## Build the site with Hugo
	@hugo --destination $(OUTPUTDIR)

.PHONY: all
all: build ## Build Everything

#
# Deploy Targets
#

.PHONY: check-deploy-vars
check-deploy-vars: ## Ensure deploy vars have been set
	@[ "${DEPLOY_USER}" ] || ( echo ">> DEPLOY_USER is not set"; exit 1 )
	@[ "${DEPLOY_HOST}" ] || ( echo ">> DEPLOY_HOST is not set"; exit 1 )

.PHONY: deploy
deploy: check-deploy-vars clean all ## Build and deploy all of kennethbowen.com
	rsync -avz --exclude-from .rsyncignore -e ssh --delete $(OUTPUTDIR)/ $(DEPLOY_USER)@$(DEPLOY_HOST):kennethbowen.com

.PHONY: try
try: all ## Run the site in a Hugo webserver
	hugo server --destination $(OUTPUTDIR) --disableFastRender

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-19s\033[0m %s\n", $$1, $$2}'
