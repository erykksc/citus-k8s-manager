# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Kubernetes manager for Citus PostgreSQL clusters. The application (`manager_k8s.py`) runs as a pod in Kubernetes and automatically discovers worker pods, then registers them with the Citus master node to form a distributed PostgreSQL cluster.

## Architecture

- **Single Python application**: `manager_k8s.py` - the main manager that runs continuously
- **Kubernetes integration**: Uses the Kubernetes Python client to watch for worker pods
- **PostgreSQL/Citus integration**: Connects to Citus master using psycopg2 to register workers
- **Docker deployment**: Containerized application designed to run in Kubernetes

## Key Components

- `connect_to_master()`: Establishes connection to Citus master node using environment variables
- `sync_workers()`: Main synchronization logic that discovers ready worker pods and registers them with Citus
- `get_ready_worker_pods()`: Queries Kubernetes API for healthy worker pods matching label selector
- `add_worker()`: Registers a worker node with the Citus cluster using `master_add_node()`

## Development Commands

### Local Development (with Nix)
```bash
# Enter development environment
nix develop

# Install Python dependencies
pip install -r requirements.txt

# Format code
black manager_k8s.py
```

### Docker Build
```bash
# Build container image
docker build -t citus-k8s-manager .

# Test container locally (requires environment variables)
docker run --rm -e CITUS_HOST=localhost -e POSTGRES_PASSWORD=mypass citus-k8s-manager
```

## Environment Variables

The application requires these environment variables:
- `CITUS_HOST`: Hostname of the Citus master node
- `POSTGRES_PASSWORD`: Password for PostgreSQL connection
- `POSTGRES_USER`: PostgreSQL username (default: postgres)
- `POSTGRES_DB`: PostgreSQL database name (default: postgres)
- `POD_NAMESPACE`: Kubernetes namespace to watch for worker pods
- `LABEL_SELECTOR`: Kubernetes label selector to find worker pods (e.g., "app=citus,role=worker")
- `SCAN_INTERVAL_SECONDS`: How often to scan for changes (default: 20)

## Deployment

The application is designed to run as a Kubernetes pod with:
- Service account permissions to list pods in the namespace
- Network access to both Kubernetes API and Citus master
- Readiness/liveness probe checking `/healthcheck/manager-ready`

Docker images are automatically built and pushed to GHCR on push to main branch or version tags.