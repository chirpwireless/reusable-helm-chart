# Reusable Helm Chart

A flexible and reusable Helm chart for deploying applications on Kubernetes.

## Features

- Configurable deployment options for various application types
- Support for HTTP and gRPC health probes
- Flexible port configuration (supports both integer and string values)
- Configurable resource limits and requests
- Support for environment variables, secrets, and config maps
- Ingress configuration with TLS support
- Service configuration with multiple port options

## Installation

### Prerequisites

- Kubernetes 1.16+
- Helm 3.7+

### Adding the Helm Repository

```bash
helm repo add chirpwireless https://chirpwireless.github.io/reusable-helm-chart
helm repo update
```

### Installing the Chart

```bash
helm install my-release chirpwireless/reusable-helm-chart
```

To install the chart with custom values:

```bash
helm install my-release chirpwireless/reusable-helm-chart -f values.yaml
```

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter            | Description           | Default        |
| -------------------- | --------------------- | -------------- |
| `image.repository`   | Image repository      | `nginx`        |
| `image.tag`          | Image tag             | `latest`       |
| `image.pullPolicy`   | Image pull policy     | `IfNotPresent` |
| `service.type`       | Service type          | `ClusterIP`    |
| `service.port`       | Service port          | `80`           |
| `ingress.enabled`    | Enable ingress        | `false`        |
| `resources.limits`   | Pod resource limits   | `{}`           |
| `resources.requests` | Pod resource requests | `{}`           |

For a complete list of parameters, see the [values.yaml](./values.yaml) file.

## Health Probes

The chart supports both HTTP and gRPC health probes:

### HTTP Probes

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: http
    scheme: HTTP
```

### gRPC Probes

```yaml
livenessProbe:
  grpc:
    port: 8080
    service: my.service.name
```

## Contributing

### Commit Message Format

This repository follows [Conventional Commits](https://www.conventionalcommits.org/) for automatic versioning:

- `feat:` - New features (minor version bump)
- `fix:` - Bug fixes (patch version bump)
- `docs:` - Documentation changes (no version bump)
- `style:` - Code style changes (no version bump)
- `refactor:` - Code refactoring (no version bump)
- `perf:` - Performance improvements (patch version bump)
- `test:` - Adding tests (no version bump)
- `chore:` - Maintenance tasks (no version bump)
- `BREAKING CHANGE:` - Breaking changes (major version bump)

Example:

```
feat: add support for gRPC probes
```

### Development Workflow

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
