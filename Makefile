.PHONY: update-examples update-config-template validate-config lint

update-examples:
	./update-examples.sh

update-config-template:
	./start-generator.sh

validate-config:
	./validate-config.sh

lint:
	CGO_ENABLED=1 GOGC=1 golangci-lint run -c .golangci.yml --timeout 10m

