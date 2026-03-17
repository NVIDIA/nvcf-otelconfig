# AGENTS.md

## Project Overview

This is the **NVCF OpenTelemetry Configuration Library** (nvcf-otelconfig), a Go library that generates OpenTelemetry Collector configuration YAML based on input from the NVCF API. The library handles:

- Generation of OpenTelemetry Collector configurations for various backends (Grafana Cloud, Datadog, Azure Monitor, etc.)
- Platform metrics collection (cadvisor, Kube state metrics, GPU/DCGM, OpenTelemetry Collector)
- Telemetry attribute enrichment
- Support for both Kubernetes and VM deployments
- Support for both container and Helm chart-based workloads
- Template-based configuration generation

**Key Components:**
- `config/` - Core configuration rendering logic (`RenderOtelConfig`)
- `backendconfig/` - Backend-specific configuration templates and embedded configs
- `generator/` - Python-based generator for creating configuration templates
- `testdata/` - Test fixtures and example configurations
- `validator/` - End-to-end validation tools

## Build and Test Commands

### Build
```bash
# No build target needed - this is a library package
# Import and use in your Go code:
import "github.com/NVIDIA/nvcf-otelconfig/config"
```

### Test
```bash
# Run all tests
go test ./...

# Or manually:
go test ./config/... ./backendconfig/...

# Run tests with verbose output
go test ./... -v

# Run tests for a specific package
go test ./config/...

# Run a specific test
go test ./config/ -run TestRenderOtelConfig
```

### Try It Out
```bash
# Use the example in testdata/create
cd testdata/create
go run main.go
```

### Update Generated Files
```bash
# Regenerate configuration templates (requires uv; see Regenerating Configuration Templates for fallback)
make update-config-template

# Regenerate examples
make update-examples

# Validate generated configurations
make validate-config
```

## Go Version

- **Required:** Go 1.22+
- **Toolchain:** Go 1.22.12
- CI uses Go 1.22.12

## Code Structure

```
nvcf-otelconfig/
├── config/                    # Core configuration rendering
│   ├── render.go             # Main RenderOtelConfig function
│   ├── telemetries.go        # Telemetry type definitions
│   └── render_test.go        # Tests
├── backendconfig/            # Backend configuration templates
│   ├── embed_config.go       # Embedded configuration templates
│   ├── types.go              # Backend configuration types
│   ├── templates/            # Generated configuration templates
│   └── source_templates/     # Source templates for generator
├── generator/                # Python-based template generator
│   ├── generator.py          # Main generator script
│   └── source-config.yaml    # Source configuration
├── testdata/                 # Test fixtures and examples
│   └── create/              # Example usage
└── validator/                # E2E validation tools
```

## Testing Instructions

### Test Organization

Tests are organized alongside their implementation files with `_test.go` suffix. Major test files include:

- `config/render_test.go` - Configuration rendering tests
- `backendconfig/embed_config_test.go` - Embedded config tests

### Writing Tests

1. Use `testify` for assertions (`github.com/stretchr/testify`)
2. Use table-driven tests with named test cases
3. Example pattern:

```go
func TestMyFunction(t *testing.T) {
    type spec struct {
        name     string
        input    string
        expected string
        expError string
    }
    
    cases := []spec{
        {name: "valid case", input: "foo", expected: "bar"},
        {name: "error case", input: "bad", expError: "expected error message"},
    }
    
    for _, tt := range cases {
        t.Run(tt.name, func(t *testing.T) {
            result, err := MyFunction(tt.input)
            if tt.expError != "" {
                assert.EqualError(t, err, tt.expError)
            } else {
                require.NoError(t, err)
                assert.Equal(t, tt.expected, result)
            }
        })
    }
}
```

### Test Data Management

- Test data lives in `testdata/` directory
- Example configurations are in `testdata/create/`
- After modifying templates, regenerate examples:
  ```bash
  make update-examples
  ```
- Always verify generated examples are current before committing:
  ```bash
  git diff byoo-otel-collector/
  ```

### CI Pipeline

The GitLab CI pipeline runs:
1. **check-version-changelog-modified** - Validates VERSION and CHANGELOG.md were modified
2. **check-generated-examples** - Validates examples are up-to-date
3. **check-generated-configs** - Validates configuration templates are up-to-date
4. **lint** - Runs golangci-lint
5. **test-unit** - Runs `go test ./...`
6. **test-otel-configs** - Validates generated configurations with otel collector

## Code Style Guidelines

### General Go Conventions
- Follow standard Go formatting: `gofmt` and `go vet`
- Use meaningful variable names; avoid single-letter variables except in short loops
- Keep functions focused and reasonably sized
- Document exported functions, types, and constants

### Linting
- Uses `golangci-lint` with configuration in `.golangci.yml`
- Run `make lint` before committing to catch style violations
- Linting runs with 10-minute timeout
- Header checking is enforced via `goheader` linter using `.goheader.tmpl`

### Project-Specific Conventions

1. **Error Handling**
   - Use `fmt.Errorf` with `%v` or `%w` for wrapping errors
   - Return descriptive error messages with context
   - Use `errors.Join()` for collecting multiple errors

2. **YAML Generation**
   - Use `gopkg.in/yaml.v3` for YAML marshaling
   - Ensure generated YAML is valid and properly formatted
   - Test with actual OpenTelemetry Collector binary

3. **Template Management**
   - Source templates are in `backendconfig/source_templates/`
   - Generated templates are in `backendconfig/templates/`
   - Use `make update-config-template` to regenerate after changes
   - Never manually edit generated templates

4. **Testing**
   - Use table-driven tests with `type spec struct`
   - Name test cases descriptively
   - Use `require` for fatal assertions, `assert` for non-fatal
   - Test with real telemetry backends when possible

5. **Documentation Files**
   - **DO NOT** create new markdown files (*.md) for documentation unless adding a significant new feature
   - Design decisions, implementation notes, and small changes should be documented in code comments
   - Only create documentation files for major features that require user-facing documentation
   - Update existing documentation (README.md, AGENTS.md) rather than creating new files

## Security Considerations

### Configuration Security

⚠️ **IMPORTANT**: This library generates configurations that may contain sensitive information:

1. **Endpoint URLs** - May contain authentication tokens or API keys
2. **Telemetry Data** - May contain sensitive application data
3. **Configuration Files** - Should be stored securely (Kubernetes Secrets, ConfigMaps)

2. **Testing with Credentials**
   - Use dummy/fake endpoints in tests
   - Never commit real API keys or tokens to testdata
   - Use environment variables for sensitive test data

3. **Generated Configurations**
   - Validate all generated YAML before deployment
   - Use `make validate-config` to verify configurations
   - Review generated configs for sensitive data exposure

## Commit Message Guidelines

### Format

This project uses **conventional commit messages** for automatic versioning:

```
<type>(<scope>): <description>

[optional body]
```

### Commit Types & Version Bumps

- `perf(scope): description` → **Major version** bump (x.0.0)
- `feat(scope): description` → **Minor version** bump (x.y.0)
- `fix(scope): description` → **Patch version** bump (x.y.z)
- Other formats → **Patch version** bump (x.y.z)

### Examples

```bash
# Major version bump
git commit -m "perf(config): optimize config generation by 50%"

# Minor version bump  
git commit -m "feat(config): add support for new telemetry backend"

# Patch version bump
git commit -m "fix(render): handle empty telemetry configs gracefully"

# Also patch version bump
git commit -m "docs: update AGENTS.md with testing instructions"
```

### Scope Suggestions

- `config` - Core configuration rendering
- `backendconfig` - Backend-specific templates
- `generator` - Template generator
- `telemetries` - Telemetry type definitions
- `test` - Test infrastructure
- `docs` - Documentation

## Development Workflow

### Before Committing

```bash
# 1. Run all tests
go test ./...

# 2. Run linting
make lint

# 3. Regenerate templates if backendconfig or config changed
make update-config-template

# 4. Regenerate examples if needed
make update-examples

# 5. Validate generated configurations
make validate-config

# 6. Verify generated files are committed
git status
```

### Adding New Features

1. **Add tests first** (TDD approach recommended)
2. Implement the feature in the appropriate package
3. Update templates if adding new backends: `make update-config-template`
4. Regenerate examples: `make update-examples`
5. Verify all tests pass: `go test ./...`
6. Validate configurations: `make validate-config`
7. Update existing documentation (README.md, AGENTS.md) if adding new APIs
   - **Do not create new markdown files** unless the feature is significant and requires standalone documentation
   - Document design decisions in code comments, not separate files
8. Use appropriate commit message type (`feat`, `fix`, `perf`)

### Modifying Configuration Templates

If adding/changing configuration templates:

1. Update source templates in `backendconfig/source_templates/`
2. Run `make update-config-template` to regenerate templates (see [Regenerating Configuration Templates](#regenerating-configuration-templates))
3. Update generator if needed (Python code in `generator/`)
4. Regenerate examples: `make update-examples`
5. Validate: `make validate-config`
6. Test with actual OpenTelemetry Collector
7. Update documentation if adding new backends or features

### Regenerating Configuration Templates

The templates in `backendconfig/templates/` are generated from `backendconfig/source_templates/` and `generator/source-config.yaml`. The generator produces output into `generator/gen/`, which must then be copied into `backendconfig/templates/`.

**Method 1: Using make (requires uv)**

```bash
make update-config-template
```

This runs `start-generator.sh`, which uses `uv sync` and `uv run -m generator`, then copies the generated files into `backendconfig/templates/`.

**Method 2: Without uv (fallback)**

If `uv` is not installed, run the generator with plain Python and copy the output manually:

```bash
cd generator
python3 generator.py -c source-config.yaml -do doc -to gen
```

Then copy the generated templates into `backendconfig/templates/`:

```bash
cd ..
for f in config-k8s-helm.yaml.tmpl config-k8s-container.yaml.tmpl config-vm-helm.yaml.tmpl config-vm-container.yaml.tmpl; do
  cp generator/gen/generated_src-${f} backendconfig/templates/${f}
done
```

**After regenerating templates:**

- Run `make update-examples` to refresh the `byoo-otel-collector/` example configs (they are rendered from the embedded templates at runtime).
- Run `make validate-config` to verify the generated YAML is valid.

### Working with Telemetry Backends

When working on backend support:

1. Review `config/telemetries.go` for telemetry type definitions
2. Check `backendconfig/source_templates/` for template structure
3. Test with real backend endpoints (use test credentials)
4. Validate generated YAML with otel collector binary
5. Update examples in `testdata/`

### Generated Code

Some files are auto-generated:
- `backendconfig/templates/*.yaml.tmpl` - Generated from source templates
- `backendconfig/embed_config.go` - Contains embedded templates
- `byoo-otel-collector/` - Generated example configurations

- Do not manually edit generated files
- Regenerate using `make update-config-template` and `make update-examples`
- Commit generated files along with source changes

## Pre-commit Hooks

This repository uses [pre-commit](https://pre-commit.com) to automatically:
- Regenerate examples when `backendconfig/` or `config/` files change
- Regenerate configuration templates
- Validate configurations

Setup:
```bash
pip install pre-commit>=4.2.0
pre-commit install --hook-type pre-push
```

## Common Gotchas

1. **Template regeneration** - Always run `make update-config-template` after modifying source templates
2. **Example regeneration** - Run `make update-examples` after template changes
3. **YAML validation** - Use `make validate-config` to verify generated YAML is valid
4. **Embedded configs** - `embed_config.go` must be regenerated when templates change
5. **Version/CHANGELOG** - CI requires VERSION and CHANGELOG.md to be modified on MRs
6. **Python generator** - The generator uses Python with uv for dependency management

## Useful Commands Reference

```bash
# Run specific test file
go test ./config/render_test.go -v

# Run tests matching a pattern
go test ./... -run TestRenderOtelConfig

# Check Go module dependencies
go mod tidy
go mod verify

# View test coverage
go test ./... -cover

# Generate detailed coverage report
go test ./... -coverprofile=coverage.out
go tool cover -html=coverage.out

# Regenerate everything
make update-config-template
make update-examples
make validate-config

# Find all test files
find . -name '*_test.go' -not -path './vendor/*' -not -path './validator/*' -not -path './generator/*'
```

## Additional Resources

- Go module: `github.com/NVIDIA/nvcf-otelconfig`
- Dependencies managed via Go modules
- CI/CD: GitLab CI (see `.gitlab-ci.yml`)
- Generator documentation: `generator/doc/README.md`
- Validator documentation: `validator/README.md`
