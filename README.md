[Key Features](#key-features) | [Quick Start](#quick-start) | [Development](#development) | [Documentation](#documentation) | [Requirements](#requirements)

# NVCF OpenTelemetry Configuration Library

A Go library for generating OpenTelemetry Collector configuration YAML based on input from the NVCF API. This library produces production-ready OpenTelemetry Collector configurations for various telemetry backends, supporting platform metrics collection, attribute enrichment, and integration with BYOO (Bring Your Own Observability) infrastructure. It supports both Kubernetes and VM deployments with container and Helm chart-based workloads.

## Key Features

### ⚙️ Configuration Generation

Generates OpenTelemetry Collector configuration YAML from NVCF API input. The `RenderOtelConfig` function returns a `[]byte` that must be used in the `data` field for the component generating the ConfigMap for the [byoo-otel-collector](https://github.com/NVIDIA/nvcf-byoo-otel-collector).

**Supported Deployment Types:**
- **Kubernetes Deployments** → Container and Helm chart workloads
- **VM Deployments** → Container and Helm chart workloads
- **Multiple Backends** → Grafana Cloud, Datadog, Azure Monitor, and more

The configuration generation is template-based, with source templates in `backendconfig/source_templates/` that are processed by a Python generator to create embedded Go templates.

### 📊 Telemetry Processing

The configuration produced by `nvcf-otelconfig` guarantees that only `otlp` telemetry and selected platform metrics are processed and exported by the collector using the generated configuration.

**Platform Metrics Sources:**
- **cadvisor** - Container resource usage metrics
- **Kube state metrics** - Kubernetes resource state metrics ([complete list](https://github.com/kubernetes/kube-state-metrics/tree/main/docs/metrics))
- **GPU/DCGM** - GPU telemetry from NVIDIA Data Center GPU Manager ([DCGM exporter](https://docs.nvidia.com/datacenter/dcgm/latest/gpu-telemetry/dcgm-exporter.html))
- **OpenTelemetry Collector** - Collector self-monitoring metrics

See the [complete metrics list](generator/doc/README.md#metrics-details) for detailed information.

### 🏷️ Attribute Enrichment

All traces, logs, and metrics have OpenTelemetry attributes added to their metadata. See the [complete attributes list](generator/doc/README.md#opentelemetry-attributes) for detailed information.

**Platform Metrics Attributes:**

- **cadvisor**: container, cpu, device, image, job[1], service[2], interface, pod
- **kube state metrics**:
  - **container**: container[3], job[1], service[2], pod, reason
  - **helm**: condition, configmap, container[3], created_by_kind, created_by_name, deployment, host_network, image, job[1], phase, pod, qos_class, reason, replicaset, resource, secret, service, statefulset, status and unit
- **DCGM**: container, DCGM_FI_DRIVER_VERSION, device, job[1], service[2], modelName, pci_bus_id and pod

**Attribute Notes:**
- [1] `job` attribute is available in Grafana Cloud
- [2] `service` is used in Datadog instead of attribute `job`
- [3] `container` is not present in Azure Monitor
- [4] `service.name` is used in Azure Monitor instead of attribute `job`

### 🔧 Template-Based Architecture

Flexible template system for generating OpenTelemetry Collector configurations with support for multiple backends and deployment scenarios.

**Template Structure:**
- **Source Templates** (`backendconfig/source_templates/`) - Human-readable YAML templates
- **Generated Templates** (`backendconfig/templates/`) - Processed templates embedded in Go code
- **Python Generator** (`generator/`) - Processes source templates into embedded Go code

Templates are automatically regenerated when source files change, ensuring consistency between source and generated code.

### 🐍 Python Tools

This repo includes two Python projects that support the Go library:

- **Generator** (`generator/`) — Reads `source-config.yaml` and produces the config templates under `backendconfig/templates/` plus the platform-metrics README in `generator/doc/`. The Go code embeds these generated templates; you must run the generator (e.g. `make update-config-template`) after changing source templates or metrics so that `backendconfig/templates/` and the embedded configs stay in sync.
- **Validator** (`validator/cli/`) — Checks that metrics produced by byoo-otel-collector match expected jobs, metrics, and attributes (e.g. by querying Grafana Cloud Prometheus). It is used for end-to-end validation of deployments and for verifying that generated configs yield the correct telemetry.

Both are required for the full workflow: the generator to build the templates consumed by the Go library, and the validator to confirm that deployed configs behave as intended.

### ✅ Validation & Testing

Comprehensive validation tools ensure generated configurations are valid and functional. Validation Features:
- YAML syntax validation
- OpenTelemetry Collector binary validation
- End-to-end testing with real collector instances
- Example configuration generation and validation

Use `make validate-config` to validate generated configurations against the OpenTelemetry Collector binary.

## Quick Start

Try the library with example data:

```bash
# Use the example in testdata/create
cd testdata/create
go run main.go
```

For custom usage, create a `main.go` file or leverage the one in `testdata/create` folder. Import the `nvcf-otelconfig` package and use the `RenderOtelConfig` function:

```go
import "github.com/NVIDIA/nvcf-otelconfig/config"

// Render OpenTelemetry configuration
config, err := config.RenderOtelConfig(input)
```

If you have your own `main.go` file in a different directory structure, copy the input folder under the folder hosting the `main.go` file.

## Development

```bash
# Run all tests
go test ./...

# Run linting
make lint

# Regenerate configuration templates
make update-config-template

# Regenerate examples
make update-examples

# Validate generated configurations
make validate-config
```

### Pre-commit Hooks

This repository uses [pre-commit](https://pre-commit.com) to automatically regenerate examples, config templates, and validate configurations when files under `backendconfig/` or `config/` directories are modified.

**Setup:**
```bash
# Install pre-commit
pip install pre-commit>=4.2.0
pre-commit --version  # Should show pre-commit 4.2.0

# Enable hooks
pre-commit install --hook-type pre-push
```

This creates symlinks `.git/hooks/pre-commit` and `.git/hooks/pre-push` that invoke hooks listed in `.pre-commit-config.yaml` on each commit/push.

**After Modifying Templates:**
```bash
# Regenerate configuration templates
make update-config-template

# Regenerate examples
make update-examples
```

The CI jobs `check-generated-examples` and `check-generated-configs` will automatically ensure that these files are up to date, so please remember to commit all regenerated artifacts.

### Validation Setup

To validate generated configurations, copy `validate-config.sh` to your working directory and run it. The script assumes:

- `main.go` file exists under `testdata`
- `ESS_SECRETS_PATH` environment variable is set
- `NGC_CLI_API_KEY` environment variable is set (API key should have registry access to NGC org `qtfpt1h0bieu`, team `nvcf-core`)

**Custom OpenTelemetry Collector Binary:**
To use a custom otel collector binary for validation, follow the steps to [build otel collector from source](https://github.com/NVIDIA/nvcf-byoo-otel-collector/-/blob/main/README.md?ref_type=heads#custom-otel-collector-binary). Copy the built binary to `./_output/bin/otelcol-contrib` and `validate-config.sh` will use it to validate configurations.

## Documentation

- **[AGENTS.md](AGENTS.md)** - Comprehensive development guide including architecture, testing, code style, and commit conventions
- **[.gitlab-ci.yml](.gitlab-ci.yml)** - CI/CD pipeline configuration
- **[generator/doc/README.md](generator/doc/README.md)** - Detailed metrics and attributes documentation
- **[validator/README.md](validator/README.md)** - End-to-end validation tools documentation

## Requirements

- Go 1.22+ (toolchain: 1.22.12)
- Python 3.x with uv (for template generator)
- OpenTelemetry Collector (for validation)
