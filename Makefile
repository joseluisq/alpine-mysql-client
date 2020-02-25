run:
	@bash -c "./test.sh"
.PHONY: run

build:
	@docker build -t mysql-tools:latest .
.PHONY: build

exec:
	@docker run --rm -it \
		--name mysql-tools \
		--volume $(PWD):/root/sample \
		--workdir /root/sample \
			mysql-tools \
			mysql_exporter .env
.PHONY: exec
