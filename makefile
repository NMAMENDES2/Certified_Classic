# App name and binary path
APP = Certified_Classic
APP_EXECUTABLE = ./out/$(APP)

# Build the Go application
build: ## Build the Go binary
	mkdir -p out/
	go build -o $(APP_EXECUTABLE) ./cmd/main.go
	@echo "Build completed: $(APP_EXECUTABLE)"

# Run the Go binary
run: build ## Run the built Go binary
	chmod +x $(APP_EXECUTABLE)
	$(APP_EXECUTABLE)
	@echo "App is running"

# Clean generated files (binary and output folder)
clean: ## Clean the binary and other generated files
	rm -rf out/
	go clean
	@echo "Cleaned up build files"

# Run all (build + clean + run)
all: clean build run ## Clean, build, and run the app

# Environment variables
POSTGRES_USER=user
POSTGRES_PASSWORD=pw
POSTGRES_DB=Certified_Classic
POSTGRES_HOST=localhost
POSTGRES_PORT=5432

# Connection string
DB_URL=postgres://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@$(POSTGRES_HOST):$(POSTGRES_PORT)/$(POSTGRES_DB)?sslmode=disable

# Migration directory
MIGRATION_DIR=migrations

# Create a new migration
create-migration:
	@echo "Creating migration: $(name)"
	@go run github.com/golang-migrate/migrate/v4/cmd/migrate create -ext sql -dir $(MIGRATION_DIR) $(name)

# Apply all migrations
migrate-up:
	@echo "Applying all migrations..."
	@migrate -path $(MIGRATION_DIR) -database "$(DB_URL)" up

# Rollback the last migration
migrate-down:
	@echo "Rolling back the last migration..."
	@migrate -path $(MIGRATION_DIR) -database "$(DB_URL)" down

# Reset the database (rollback all migrations and apply them again)
migrate-reset:
	@echo "Resetting the database..."
	@migrate -path $(MIGRATION_DIR) -database "$(DB_URL)" force 0
	@migrate -path $(MIGRATION_DIR) -database "$(DB_URL)" up

# Show the current migration version
migrate-version:
	@migrate -path $(MIGRATION_DIR) -database "$(DB_URL)" version

.PHONY: create-migration migrate-up migrate-down migrate-reset migrate-version


