# Citus Kubernetes Manager

A very simply Kubernetes manager that automatically discovers and registers Citus PostgreSQL worker nodes with the coordinator node (also called master node) to form a distributed database cluster.

## Features

- Automatically discovers ready worker pods in Kubernetes using label selectors
- Registers worker nodes with the Citus coordinator using `master_add_node()`
- Continuous monitoring and synchronization
- Health check support for Kubernetes probes
- Graceful shutdown handling

## Environment Variables

| Variable                | Description                                   | Default                   |
| ----------------------- | --------------------------------------------- | ------------------------- |
| `CITUS_HOST`            | Hostname of the Citus coordinator node        | -                         |
| `POSTGRES_PASSWORD`     | Password for PostgreSQL connection            | -                         |
| `POSTGRES_USER`         | PostgreSQL username                           | `postgres`                |
| `POSTGRES_DB`           | PostgreSQL database name                      | `postgres`                |
| `POD_NAMESPACE`         | Kubernetes namespace to watch for worker pods | -                         |
| `LABEL_SELECTOR`        | Label selector to find worker pods            | `"app=citus,role=worker"` |
| `SCAN_INTERVAL_SECONDS` | Scan interval for worker discovery            | `20`                      |

## Deployment

The manager runs as a Kubernetes pod and requires:

- Service account permissions to list pods in the namespace
- Network access to both Kubernetes API and Citus coordinator
- Proper environment variables configured

## Docker Image

Images are automatically built and pushed to GitHub Container Registry:

- `ghcr.io/USERNAME/citus-k8s-manager:latest`
- `ghcr.io/USERNAME/citus-k8s-manager:v*` (for tagged releases)

