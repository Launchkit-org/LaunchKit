# LaunchKit

Multi-chain airdrop campaign platform for creating, managing, and distributing token airdrops via gamified task-based campaigns.

## Architecture

```
┌─────────────┐     ┌──────────────┐
│   Gateway    │────▶│     Core     │
│  (:8080)     │     │  (:8081)     │
│  public API  │     │  internal    │
│  auth/routes │     │  logic       │
└──────┬───────┘     └──────┬───────┘
       │                    │
       ▼                    ▼
┌──────────────────────────────┐
│         shared/              │
│  config, jwt, cache, logger  │
│  encryptor, serializer, etc  │
└──────────┬───────────────────┘
           │
     ┌─────▼──────┐
     │   db/      │
     │  sqlc gen  │
     │  goose     │
     └─────┬──────┘
           │
     ┌─────▼──────┐
     │ PostgreSQL │
     │   Redis    │
     └────────────┘
```

- **gateway** — Public-facing HTTP API (auth, project/campaign CRUD)
- **core** — Internal service handling business logic
- **shared** — Common library (config, JWT, cache, logger, encryption, serialization)
- **db** — Database schema, migrations (goose), and sqlc-generated Go data layer
- **deployments** — Docker Compose orchestration (Postgres 18, Redis 8, pgAdmin)

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Go 1.26 |
| HTTP | Fiber v3 |
| Database | PostgreSQL 18 (pgx/v5) |
| DB Codegen | sqlc |
| Migrations | goose |
| Cache | Redis 8 (go-redis/v9) |
| Config | Viper (YAML + env overlay) |
| Auth | JWT HS256 (access + refresh tokens) |
| Logging | zerolog + lumberjack |
| Serialization | sonic |
| Encryption | AES-256-GCM |
| Dev | air (live reload), Docker Compose |
| Task Runner | Taskfile |

## Database Schema

10 tables covering the full domain:

| Table | Purpose |
|---|---|
| `users` | Wallet-based user profiles with ENS and social identities |
| `projects` | Company/org info, token metadata, treasury wallet |
| `project_api_keys` | Hashed API keys for webhook verification |
| `project_members` | RBAC with invitation workflow |
| `campaigns` | Full campaign lifecycle with JSONB configs |
| `tasks` | Campaign tasks with frontend/backend verification types |
| `task_completions` | User submissions with proof, points, leaderboard |
| `auth_nonces` | Wallet challenge-response authentication |
| `audit_logs` | Immutable action log per project |
| `campaign_analytics_snapshots` | Periodic campaign metrics |

## Development

### Prerequisites

- Go 1.26+
- Docker & Docker Compose
- Taskfile ([task](https://taskfile.dev))

### Quick Start

```bash
# Start infrastructure and boot services
task start

# Or step by step:
task up         # docker compose up -d
task migrate-up  # apply database migrations
task logs       # tail all service logs
```

### Available Tasks

| Task | Description |
|---|---|
| `up` | Start Docker services |
| `down` | Stop and remove all containers/volumes |
| `build` | Rebuild Docker images |
| `logs` | Tail container logs |
| `migrate-status` | Show migration status |
| `migrate-up` | Apply pending migrations |
| `migrate-down` | Roll back last migration |
| `migrate-redo` | Re-run latest migration |
| `migrate-create -- <name>` | Create a new migration |
| `gen-sqlc` | Regenerate sqlc Go code |
| `tidy [module]` | Run `go mod tidy` on a module or all |
| `start` | Full boot (infra → migrate → logs) |

### Environment

Copy `.env.example` to `.env` and configure:

| Variable | Purpose |
|---|---|
| `POSTGRES_*` | Database connection |
| `REDIS_ADDR`, `REDIS_PASSWORD` | Redis connection |
| `ACCESS_SECRET`, `REFRESH_SECRET` | JWT signing keys |
| `CONFIG_PATH` | Path to YAML config |

## Status

Early development — `gateway` and `core` are stubs with health endpoints. The data layer (migrations + sqlc queries) and shared library are fully defined.
