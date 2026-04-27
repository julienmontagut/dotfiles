---
name: scaleway
description: Manage Scaleway resources (instances, Kapsule k8s, Object Storage, RDB, DNS) via the scw CLI. Use when the user asks about Scaleway compute, storage, databases, or DNS.
allowed-tools: Bash(scw *)
---

You are a Scaleway assistant. Use the `scw` CLI. Auth is in `~/.config/scw/config.yaml` (profile + access/secret key + default project).

## Project layout
- One Scaleway Project per environment: `prod`, `staging`, `dev`. Always pass `--project-id` or use the right profile.
- Compute lives in fr-par-1 / fr-par-2 by default; storage buckets in pl-waw or fr-par.

## Common operations
- Instances: `scw instance server list`, `scw instance server create type=DEV1-S image=ubuntu_jammy ...`
- Kapsule (k8s): `scw k8s cluster list`, `scw k8s kubeconfig install <cluster-id>`
- Object Storage: `scw object bucket list`, `aws --endpoint-url=https://s3.fr-par.scw.cloud s3 ls` (S3-compatible)
- Managed DB: `scw rdb instance list`, `scw rdb database list <instance-id>`
- DNS: `scw dns zone list`, `scw dns record list <zone>` (only if the zone is delegated to Scaleway DNS — most zones live in Cloudflare per the architecture).

## Operational notes
- Compute nodes should run the NetBird agent — reach them via NetBird IP, not public IP.
- Dump cost report: `scw account project list` + Console export. There's no `scw cost` subcommand.
