# AGENTS.md

## Project Structure

```
chart/
├── Chart.yaml           # Chart metadata (version managed by semantic-release)
├── values.yaml          # Default values with documentation
├── values.schema.json   # JSON Schema for validation
└── templates/
    ├── _helpers.tpl     # Template helpers (fullname, labels, affinity, initContainers, sidecars)
    ├── deployment.yaml  # Main workload (mutually exclusive with statefulset)
    ├── gateway-api/     # Envoy Gateway resources (HTTPRoute, GRPCRoute, TLSRoute, SecurityPolicy, BackendTrafficPolicy)
    └── ...
```

## Development Commands

```bash
# Lint
helm lint chart
ct lint --charts chart

# Template validation
helm template chart --debug

# Test with values
helm template my-app chart -f test-values.yaml
```

## Key Implementation Details

- **Affinity**: Hardcoded pod anti-affinity in `_helpers.tpl` (zone preferred, hostname required)
- **Version sync**: `Chart.yaml` version is updated automatically by release workflow, don't edit manually
- **ExternalSecrets**: Uses `external-secrets.io/v1` API, `path` field in values maps to `key` in template
- **Gateway API**: Targets Envoy Gateway (`gateway.envoyproxy.io/v1alpha1` for policies)

## Template Conventions

- Use `include "reusable-helm-chart.fullname"` for resource names
- Range over lists for multiple resources (ingress, httpRoutes, cronjob)
- Conditional creation: `{{- if .Values.feature.enabled }}`

## Release Process

1. Commit with conventional commit message
2. Merge to `release` branch
3. Workflow runs: lint → semantic-release → package → deploy to gh-pages
