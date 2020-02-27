build:
	@docker build -t alpine-mysql-client:latest -f docker/Dockerfile .
.PHONY: build

exec:
	@docker run --rm -it \
		--user mysql \
		--name alpine-mysql-client \
		--volume $(PWD):/home/mysql/sample \
		--workdir /home/mysql/sample \
			alpine-mysql-client:latest \
			mysql_exporter .env
.PHONY: exec

release:
	# 1. Get latest git tag
	$(eval GIT_TAG := $(shell git tag -l --contains HEAD))

	# 2. Update docker files to latest tag
	./docker/version.sh $(GIT_TAG)

	# 3. Commit and push to latest tag
	git add docker/Dockerfile
	git commit docker/Dockerfile -m "$(GIT_TAG)"
	git push origin master
	git push origin $(GIT_TAG)
.ONESHELL: release
