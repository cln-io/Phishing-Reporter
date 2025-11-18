.PHONY: build clean run download help

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: download ## Download latest build from GitHub Actions (recommended)

download: ## Download latest build from GitHub Actions
	@echo "📥 Downloading latest build from GitHub Actions..."
	@./build-local.sh

run: download ## Download and show artifacts
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
