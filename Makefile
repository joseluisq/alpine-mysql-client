run:
	@bash -c "./test.sh"
.PHONY: run

build:
	@docker build -t alpine-mysql-client:latest .
.PHONY: build

exec:
	@docker run --rm -it \
		--name alpine-mysql-client \
		--volume $(PWD):/root/sample \
		--workdir /root/sample \
			alpine-mysql-client:latest \
			mysql_exporter .env
.PHONY: exec
