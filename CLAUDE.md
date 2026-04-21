# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A collection of `dotnet new` templates for the Cloud-Tek **Hive** framework (https://github.com/cloud-tek/). Each top-level folder (except `scripts/` and `.github/`) is a standalone template that is installed into the local `dotnet` CLI and rendered into a new solution via `dotnet new hive-<template-name>`.

Templates:
- `job` → `hive-job` (one-shot k8s-style cronjob)
- `microservice` → `hive-microservice` (long-running background processor, no HTTP API)
- `microservice-api` → `hive-microservice-api` (REST, controller-based)
- `microservice-minimal-api` → `hive-microservice-minimal-api` (REST, minimal APIs)
- `microservice-graphql-api` → `hive-microservice-graphql-api` (HotChocolate)
- `microservice-grpc-api` → `hive-microservice-grpc-api` (gRPC, `.proto`-first)
- `microservice-grpc-minimal-api` → `hive-microservice-grpc-minimal-api` (gRPC, code-first)

## Common commands

Install/refresh all templates locally (uninstalls then reinstalls each):
```pwsh
./Install-Templates.ps1
```

Render a template manually for inspection:
```bash
dotnet new -i ./<template-folder>
dotnet new hive-<template-name> -pr <ProjectName> -svc <ServiceName> [--solution false]
```

Run the full Pester test suite (runs against all 7 templates):
```pwsh
./Tests.ps1
```

Run only rendering tests (fast — renders each template with/without `--solution`, checks expected files exist):
```pwsh
Invoke-Pester ./Tests.ps1 -Tag "template-rendering"
```

Run only build tests (slow — renders each template and runs `dotnet restore` + `dotnet build`):
```pwsh
Invoke-Pester ./Tests.ps1 -Tag "template-build"
```

Build a template's reference solution directly (without rendering), as CI's `pre-build-templates` job does:
```bash
cd <template-folder>
dotnet restore ProjectName.ServiceName.sln
dotnet build ProjectName.ServiceName.sln
```

## Architecture

### Template layout
Every template folder has the same shape:
```
<template>/
  .template.config/
    template.json          # dotnet-new template metadata + parameters
    dotnetcli.host.json
  src/
    ProjectName.ServiceName.<Suffix>/   # the actual project (Svc, Api, Job, GraphQL, Grpc, ...)
  ProjectName.ServiceName.sln           # excluded when --solution false
  LICENSE                               # excluded when --solution false
  readme.md                             # excluded when --solution false
```

The folder at the root of each template is **both** a buildable reference solution (CI pre-builds it directly) **and** the source that `dotnet new` renders. This dual role matters: any change to source files must leave the reference `.sln` building AND render correctly through the templating engine.

### Tokens replaced at render time
Defined in each `.template.config/template.json`:

| Token in source | Replaced with | Source |
|---|---|---|
| `ProjectName` | `-pr` parameter (default `CloudTek`) | file contents + filenames |
| `ServiceName` | `-svc` parameter (default `Service`) | file contents + filenames |
| `ProjectNameLower` | lowercased `project` | file contents + filenames |
| `ServiceNameLower` | lowercased `service` | file contents + filenames |

The lowercase variants are used in runtime service identifiers (see e.g. `new MicroService("ProjectNameLower-ServiceNameLower-svc")` in [microservice/src/ProjectName.ServiceName.Svc/Program.cs](microservice/src/ProjectName.ServiceName.Svc/Program.cs)). The `--solution` bool parameter toggles exclusion of the sln/LICENSE/readme/editorconfig via `sources.modifiers` in `template.json`.

### csproj suffix per template
Project folder + `.csproj` name suffix differs per template and is encoded in [scripts/TestSuite.psm1](scripts/TestSuite.psm1) (`$csprojSuffix`). When adding/renaming a template, update both `template.json` and `TestSuite.psm1` so the build test can locate the rendered project.

### Hive dependencies
Templates reference `Hive.MicroServices`, `Hive.MicroServices.Api`, `Hive.Analyzers`, etc. from **private Cloud-Tek NuGet feeds** (`nuget.cloudtek.io`, `nuget.cloud-tek.io`). Local `dotnet restore` on a rendered template will fail unless a `nuget.config` with credentials is present. CI writes one at runtime in [.github/workflows/ci.yml](.github/workflows/ci.yml) from repo secrets (`NUGET_FEED_*`, `NUGET_USERNAME`, `NUGET_PASSWORD`).

### CI pipeline shape
Three sequential jobs in a matrix of `{ubuntu-latest, macos-latest} × dotnet 7.0.101`:
1. `pre-build-templates` — `dotnet build` each template's reference solution directly (catches broken source before templating).
2. `render-templates` — Pester `template-rendering` tag (dotnet-new renders all templates).
3. `post-build-templates` — Pester `template-build` tag (renders, then builds each rendered project).

If you change template source: all three will catch regressions. If you change only `.template.config/template.json`: only jobs 2 and 3 will.

## Conventions

- All projects target **net7.0**, `LangVersion 11.0`, `Nullable enable`, `ImplicitUsings enable`, `TreatWarningsAsErrors true`. Warnings *are* errors — don't silence with `#pragma`, fix them.
- Indent is **2 spaces** everywhere (`.editorconfig`), including `.cs`, `.csproj`, `.yml`, `.ps1`.
- Hive package versions are pinned to the `7.*` floating major. Bumping the framework major (e.g. net7 → net8) touches every template's `.csproj` + the CI matrix + the Hive package version floats — see commit `38b9129` for the shape of a prior framework upgrade.
