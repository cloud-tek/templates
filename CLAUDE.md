# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A collection of `dotnet new` templates for the Cloud-Tek **Hive** framework (https://github.com/cloud-tek/hive). Each top-level folder (except `scripts/` and `.github/`) is a standalone template that is installed into the local `dotnet` CLI and rendered into a new solution via `dotnet new hive-<template-name>`.

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

Run a single test case (e.g. only the `job` rendering test):
```pwsh
Invoke-Pester -Path ./Tests.ps1 -FullNameFilter "*service type: job*"
```

Build a template's reference solution directly (without rendering), as CI's `pre-build-templates` job does:
```bash
cd <template-folder>
dotnet restore ProjectName.ServiceName.sln
dotnet build ProjectName.ServiceName.sln
```

**Pester gotcha**: the test file is named `Tests.ps1`, not `*.Tests.ps1`. Pester's default discovery glob is `*.Tests.ps1`, so a bare `Invoke-Pester` (no `-Path`) in the repo root finds zero tests. Always pass the explicit path as shown above. CI already does this in [.github/workflows/ci.yml](.github/workflows/ci.yml).

**Test authoring rule — always pass `--force` to `dotnet new -i`**: Any test or helper that shells out to `dotnet new -i <template>` MUST include `--force` (see [scripts/TestSuite.psm1](scripts/TestSuite.psm1) for the canonical pattern). Without it, re-installing an already-installed template exits non-zero and writes to stderr. In PowerShell 7.3+, native-command stderr surfaces as `ErrorRecord` objects, which the VS Code Pester extension's PesterInterface reads and reports as test errors — tests still pass in the runner, but the UI lights up red. The CLI Pester run is unaffected, so this bug is invisible until someone uses the extension.

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
Templates reference `Hive.MicroServices`, `Hive.MicroServices.Api`, `Hive.MicroServices.Job`, `Hive.MicroServices.GraphQL`, `Hive.MicroServices.Grpc` from nuget.org. CI additionally wires up the private **Cloud-Tek NuGet feed** (`nuget.cloudtek.io`) for transitive deps — see the runtime-generated `nuget.config` in [.github/workflows/ci.yml](.github/workflows/ci.yml) built from repo secrets (`NUGET_FEED_CLOUDTEK`, `NUGET_USERNAME`, `NUGET_PASSWORD`). Local restore outside CI usually needs those credentials too.

`Hive.Analyzers` is **not** referenced (removed in the Hive 10 upgrade — no 10.x release of that package exists). Don't re-add it unless a 10.x ships.

### CI pipeline shape
Three sequential jobs in a matrix of `{ubuntu-latest, macos-latest} × dotnet 10.0.x`:
1. `pre-build-templates` — `dotnet build` each template's reference solution directly (catches broken source before templating).
2. `render-templates` — Pester `template-rendering` tag (dotnet-new renders all templates).
3. `post-build-templates` — Pester `template-build` tag (renders, then builds each rendered project).

If you change template source: all three will catch regressions. If you change only `.template.config/template.json`: only jobs 2 and 3 will.

## Conventions

- All projects target **net10.0**, `LangVersion 14.0`, `Nullable enable`, `ImplicitUsings enable`, `TreatWarningsAsErrors true`. Warnings *are* errors — don't silence with `#pragma`, fix them.
- Indent is **2 spaces** everywhere (`.editorconfig`), including `.cs`, `.csproj`, `.yml`, `.ps1`.
- Hive package versions are pinned to the `10.*` floating major, tracking the Hive framework major. A framework bump touches every template's `.csproj` (`TargetFramework`, `LangVersion`, Hive package floats), the CI matrix (`dotnet-version`), and any transitive deps (e.g. `Grpc.AspNetCore` in the two grpc templates — keep aligned with Hive's own `Directory.Packages.props` pin).
