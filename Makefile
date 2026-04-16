.PHONY: update-examples update-docs validate-config lint

update-examples:
	./update-examples.sh

update-docs:
	go run ./cmd/docgen/ -c backendconfig/source-config.yaml -o generator/doc/README.md

validate-config:
	./validate-config.sh

lint:
	CGO_ENABLED=1 GOGC=1 golangci-lint run -c .golangci.yml --timeout 10m

