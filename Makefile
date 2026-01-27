UID ?= $(shell id -u)
DOCKER_COMPOSE = env UID=$(UID) docker-compose -f docker-compose.yml

.PHONY: down
down:
	docker-compose down

.PHONY: build
build:
	$(DOCKER_COMPOSE) up -d --build metadata-app

.PHONY: spec
spec: setup
	$(DOCKER_COMPOSE) run --rm  metadata-app env RAILS_ENV=test bundle exec rspec

.PHONY: all_units
all_units: build
	$(DOCKER_COMPOSE) run --rm metadata-app env RAILS_ENV=test bundle exec rspec --exclude-pattern spec/integration/*_spec.rb

.PHONY: unit
unit: build
  # change to what is required
	$(DOCKER_COMPOSE) run --rm metadata-app env RAILS_ENV=test bundle exec rspec spec/requests/get_services_spec.rb

.PHONY: seed_public_key
seed_public_key:
	$(DOCKER_COMPOSE) up -d --build metadata-app-service-token-cache-redis
	ruby ./scripts/seed_test_public_key.rb

.PHONY: integration
integration: setup
	$(DOCKER_COMPOSE) run --rm metadata-app env RAILS_ENV=test bundle exec rspec spec/integration/*_spec.rb

.PHONY: load-test-local
load-test-local: setup
	./bin/wait-for-metadata-app
	cat spec/fixtures/private.pem | base64 | xargs ./bin/load-test

.PHONY: setup
setup: down seed_public_key build

.PHONY: get_private_key
get_private_key: setup
	cat spec/fixtures/private.pem | base64
