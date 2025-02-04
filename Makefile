build:
	@docker build \
		--build-arg VERSION=0.0.0 \
		-t alpine-mysql-client:latest -f Dockerfile .
.PHONY: build

export:
	@docker run --rm -it \
		--user $(HOME_USER) \
		--name alpine-mysql-client \
		--volume $(PWD):/home/mysql/sample \
		--network mysql-net \
		--workdir /home/mysql/sample \
			alpine-mysql-client:latest \
			mysql_exporter export.env
.PHONY: export

import:
	@docker run --rm -it \
		--user $(HOME_USER) \
		--name alpine-mysql-client \
		--volume $(PWD):/home/mysql/sample \
		--network mysql-net \
		--workdir /home/mysql/sample \
			alpine-mysql-client:latest \
			mysql_importer import.env
.PHONY: import
