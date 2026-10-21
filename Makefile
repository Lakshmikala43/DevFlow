.PHONY: help build test run clean docker-up docker-down measure

help:
	@echo "DevFlow Build Commands:"
	@echo "  make build       - Build both frontend and backend"
	@echo "  make test        - Run all automated tests"
	@echo "  make run         - Run the DevFlow platform locally"
	@echo "  make docker-up   - Start PostgreSQL and services via Docker Compose"
	@echo "  make docker-down - Stop Docker Compose containers"
	@echo "  make measure     - Count production source SLOC"
	@echo "  make clean       - Clean all build artifacts"

build:
	mvn clean package -DskipTests
	npm run build

test:
	node --test tests/*.test.js
	mvn test

run:
	mvn spring-boot:run

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

measure:
	python scripts/measure_loc.py

clean:
	mvn clean
	rm -rf dist target build
