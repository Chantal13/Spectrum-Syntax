.PHONY: help install serve build test webp lint clean check assets links

# Default target
.DEFAULT_GOAL := help

# Variables
BUNDLE := bundle _2.7.1_
JEKYLL := $(BUNDLE) exec jekyll
RAKE := $(BUNDLE) exec rake
PYTHON := python3

help: ## Show this help message
	@echo "Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36mmake %-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Examples:"
	@echo "  make install    # Install all dependencies"
	@echo "  make serve      # Start development server"
	@echo "  make test       # Run test suite"

install: ## Install dependencies
	@echo "Installing Ruby dependencies..."
	$(BUNDLE) install
	@echo ""
	@echo "Dependencies installed successfully!"
	@echo "Optional: Install Python dependencies for WebP generation:"
	@echo "  pip3 install Pillow pytest"

serve: ## Start development server
	@echo "Starting Jekyll development server at http://localhost:4000"
	$(JEKYLL) serve

build: ## Build the site
	@echo "Building Jekyll site..."
	$(JEKYLL) build
	@echo "Site built to _site/"

test: ## Run test suite
	@echo "Running test suite..."
	$(RAKE) test

webp: ## Generate WebP images
	@echo "Generating WebP variants..."
	$(RAKE) webp

lint: ## Run linters
	@echo "Running linters..."
	@if command -v rubocop >/dev/null 2>&1; then \
		echo "Running RuboCop..."; \
		$(BUNDLE) exec rubocop || true; \
	else \
		echo "RuboCop not installed, skipping Ruby linting"; \
	fi
	@echo ""
	@if [ -f "$(PYTHON)" ] && [ -f "scripts/canadian_english_lint.py" ]; then \
		echo "Running Canadian English linter..."; \
		$(PYTHON) scripts/canadian_english_lint.py || true; \
	else \
		echo "Python linter not available, skipping"; \
	fi

clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	@rm -rf _site .jekyll-cache .jekyll-metadata
	@echo "Clean complete!"

check: check-assets check-links ## Run all checks

check-assets: ## Check for missing assets
	@echo "Checking for missing assets..."
	ruby scripts/check_assets.rb

check-links: build ## Check for broken links (requires build)
	@echo "Checking site links..."
	$(PYTHON) scripts/check_site_links.py

check-webp: ## Check for missing WebP siblings
	@echo "Checking for missing WebP variants..."
	$(PYTHON) scripts/check_webp_siblings.py

# Development workflow shortcuts
dev: install serve ## Install dependencies and start dev server

rebuild: clean build ## Clean and rebuild the site

verify: test check ## Run tests and all checks

# Git workflow
push: ## Push changes using git_push.py helper
	@read -p "Commit message: " msg; \
	$(PYTHON) scripts/git_push.py -m "$$msg"

# Deployment
deploy-check: verify check-webp ## Pre-deployment checks
	@echo ""
	@echo "✓ All pre-deployment checks passed!"
	@echo "Ready to deploy."
