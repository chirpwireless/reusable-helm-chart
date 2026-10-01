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

`ingress` is a list of rules; each rule's `from` and `ports` follow the Kubernetes
`NetworkPolicyPeer` / `NetworkPolicyPort` shapes, with the schema closing the shapes that would open
a policy by accident:

- every rule names its sources: `from` is required and non-empty, and no source may be empty. "Any
  source" is written explicitly (`podSelector: {}` — every pod of the namespace, `namespaceSelector: {}`
  — every namespace, `ipBlock.cidr: 0.0.0.0/0`), never by omission;
- `matchLabels` / `matchExpressions` may not be empty, `In`/`NotIn` need `values`, `ipBlock` stands alone
  in its source;
- `ports`, when present, is non-empty and every entry has a `port`; omit `ports` to allow every port;
- unknown keys are refused at every level, so a typo fails the render instead of rendering nothing.

`enabled: true` with an empty (or omitted) `ingress` list denies all inbound traffic to the release's pods.

Sources the chart itself wires to the pods are not allowed automatically: the gateway or ingress
controller behind `httpRoutes` / `grpcRoutes` / `ingress`, and the scraper behind `global.metrics`,
need their own rule. A missing source does not fail the rollout — probes come from the node and still
pass — it only drops that traffic.

`ports[].port` is the container (pod) port, i.e. the Service `targetPort`, not the Service port:
writing the Service port (80 by default) silently blocks the real traffic.
A named port resolves to a container port name, which this chart takes from `service.ports[].name`.

## Contributing

Uses [Conventional Commits](https://www.conventionalcommits.org/) for semantic versioning:

- `feat:` → minor bump
- `fix:` → patch bump
- `BREAKING CHANGE:` → major bump

Release workflow: merge to `release` branch → semantic-release → GitHub Pages

Template behaviour is covered by [helm-unittest](https://github.com/helm-unittest/helm-unittest) suites in `chart/tests/`
(Helm 4, plugin 1.1.x): `helm unittest chart`. CI installs the plugin from a sha256-pinned release archive
(`.github/actions/setup-helm-unittest`).
