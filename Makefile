.PHONY: run setup

run:
	docker compose build && docker compose up -d

setup:
	./setup.sh

