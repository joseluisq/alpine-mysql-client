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
	# 2. Update docker files to latest tag
	./docker/version.sh $(ARGS)

	# 3. Commit and push to latest tag
	git add docker/Dockerfile
	git commit docker/Dockerfile -m "$(ARGS)"
	git tag $(ARGS)
	git push origin master
	git push origin $(ARGS)
.ONESHELL: release
