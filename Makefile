.PHONY: build clean run docker-build help

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build using Docker (local compilation on Mac)
	@echo "🐳 Building Phishing Reporter with Docker..."
	docker compose build
	docker compose run --rm builder
	@echo "✅ Build complete! Artifacts in ./output/"

docker-build: build ## Alias for build

run: build ## Build and show output
	@echo "📦 Build artifacts:"
	@ls -lah output/

clean: ## Clean build artifacts and Docker images
	@echo "🧹 Cleaning up..."
	rm -rf output/
	docker compose down -v
	docker rmi button-builder 2>/dev/null || true
	@echo "✅ Cleaned!"

download: ## Download latest build from GitHub Actions
	@echo "📥 Downloading from GitHub Actions..."
	./build-local.sh

rebuild: clean build ## Clean and rebuild

shell: ## Open a shell in the build container
	docker compose run --rm --entrypoint /bin/bash builder

logs: ## Show build logs
	docker compose logs builder

.DEFAULT_GOAL := help
