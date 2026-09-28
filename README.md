# Reusable Helm Chart

Universal Helm chart for deploying applications on Kubernetes.

## Features

**Workloads**: Deployment, StatefulSet, CronJob

**Networking**:

- Service (ClusterIP, NodePort, LoadBalancer)
- Ingress (nginx) with TLS
- Gateway API (Envoy): HTTPRoute, GRPCRoute, TLSRoute

**Security**:

- JWT/OIDC authentication via SecurityPolicy
- CORS configuration
- Rate limiting (local)
- RBAC (Role/ClusterRole)

**Configuration**:

- ExternalSecrets (Vault integration)
- ConfigMaps, Secrets, file mounts
- Environment variables

**Database & Messaging**:

- DB migrations (Liquibase)
- MongoDB Operator CRD
- NATS JetStream Streams/Consumers

**Observability**:

- Prometheus metrics + ServiceMonitor
- HTTP/gRPC health probes

**Scaling**:

- HPA with configurable policies
- Pod anti-affinity (zone/node distribution)
- PVC persistence

## Installation

```bash
helm repo add chirpwireless https://chirpwireless.github.io/reusable-helm-chart
helm repo update
helm install my-release chirpwireless/reusable-helm-chart -f values.yaml
```

**Requirements**: Kubernetes 1.16+, Helm 3.7+

## Configuration

See [chart/values.yaml](./chart/values.yaml) for all parameters with examples.

Key parameters:

| Parameter             | Description                                          | Default                                      |
| --------------------- | ---------------------------------------------------- | -------------------------------------------- |
| `deployment.enabled`  | Use Deployment (mutually exclusive with statefulset) | `true`                                       |
| `statefulset.enabled` | Use StatefulSet                                      | `false`                                      |
| `image.repository`    | Container image                                      | `gcr.io/google_containers/echoserver`        |
| `service.ports`       | Service port mappings                                | `[{port: 80, targetPort: 8080, name: http}]` |
| `ingress`             | Ingress configurations (list)                        | `[]`                                         |
| `httpRoutes`          | Gateway API HTTPRoutes (list)                        | `[]`                                         |
| `externalSecrets`     | Vault secrets mapping                                | `{}`                                         |
| `autoscaling.enabled` | Enable HPA                                           | `false`                                      |

## Examples

### Gateway API with JWT Auth

```yaml
httpRoutes:
  - nameSuffix: api
    parentRefs:
      - name: internal
        namespace: envoy-gateway-system
    hostnames:
      - my-app.dev.chirpwireless.io
    rules:
      - matches:
          - path: /
            pathType: PathPrefix
        servicePort: 8080
    auth:
      jwt:
        providers:
          - name: zitadel
            issuer: https://your-zitadel.zitadel.cloud
            jwksUri: https://your-zitadel.zitadel.cloud/oauth/v2/keys
```

### NATS JetStream

```yaml
natsStreams:
  my-events:
    subjects: ["events.>"]
    storage: file
    replicas: 3

natsStreamsConsumers:
  my-consumer:
    streamName: my-events
    filterSubject: "events.created"
    ackPolicy: explicit
```

## NetworkPolicy

Disabled by default, so existing consumers of the chart are unaffected. When enabled, the chart
renders a `NetworkPolicy` scoped to the release's own pods (`podSelector` matches the chart's
selector labels), restricting only ingress — egress is never limited by this chart.

```yaml
networkPolicy:
  enabled: true
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app.kubernetes.io/name: my-client
      ports:
        - port: 8080
          protocol: TCP
```

`ingress` is a list of rules; each rule's `from` and `ports` follow the standard Kubernetes
`NetworkPolicyPeer` / `NetworkPolicyPort` shapes. `enabled: true` with an empty (or omitted)
`ingress` list denies all inbound traffic to the release's pods.

## Contributing

Uses [Conventional Commits](https://www.conventionalcommits.org/) for semantic versioning:

- `feat:` → minor bump
- `fix:` → patch bump
- `BREAKING CHANGE:` → major bump

Release workflow: merge to `release` branch → semantic-release → GitHub Pages
