.PHONY: build up shell run web test clean

build:
	docker compose build

up:
	docker compose up -d

shell:
	docker compose run --rm perl bash

run:
	docker compose run --rm perl perl bin/hello.pl

web:
	docker compose up -d

test:
	docker compose run --rm perl prove -l t

clean:
	docker compose down --remove-orphans
