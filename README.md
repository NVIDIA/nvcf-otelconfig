# nvcf-otelconfig

[![CI](https://github.com/NVIDIA/nvcf-otelconfig/actions/workflows/ci.yml/badge.svg)](https://github.com/NVIDIA/nvcf-otelconfig/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Go Reference](https://pkg.go.dev/badge/github.com/NVIDIA/nvcf-otelconfig.svg)](https://pkg.go.dev/github.com/NVIDIA/nvcf-otelconfig)

OpenTelemetry configuration library and tooling for [NVIDIA Cloud Functions (NVCF)](https://docs.nvidia.com/cloud-functions/).

## Overview

`nvcf-otelconfig` provides OpenTelemetry configuration generation and validation
for NVCF observability. It supports configuring metrics, logs, and traces for
functions running on NVIDIA Cloud Functions.

## Installation

```bash
go get github.com/NVIDIA/nvcf-otelconfig
```

## Requirements

- Go 1.22 or later

## Usage

```go
import "github.com/NVIDIA/nvcf-otelconfig/config"
```

## Development

### Build

```bash
go build ./...
```

### Test

```bash
go test ./...
```

### Lint

```bash
go vet ./...
golangci-lint run ./...
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

All pull requests must be signed off with the Developer Certificate of Origin
(DCO). See [CONTRIBUTING.md](CONTRIBUTING.md) for instructions.

## License

Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.

Licensed under the [Apache License, Version 2.0](LICENSE).

## Security

Please report security vulnerabilities via [SECURITY.md](SECURITY.md).
