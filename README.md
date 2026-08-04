# base-cs-project

![.NET Version](https://img.shields.io/badge/.NET-8.0%20%7C%2010.0-blue)
![License: MIT](https://img.shields.io/badge/license-MIT-green)

## Overview

This repository is a **base template for C# projects** with a containerized development workflow. It provides a structured scaffold for .NET applications, including Docker and VS Code Dev Container configuration for easy setup.

### Key Features

- **.NET 8.0 and 10.0 multi-targeting** with automatic multi-version CI testing
- Dockerized development with `Dockerfile` and `docker-compose.yml`
- [Central Package Management](https://learn.microsoft.com/nuget/consume-packages/central-package-management) with `packages.lock.json` lock files for reproducible restores
- Strict static analysis: nullable reference types, [.NET analyzers](https://learn.microsoft.com/dotnet/fundamentals/code-analysis/overview) at `latest-Recommended`, and warnings as errors
- Formatting and code style enforced via `.editorconfig` and [dotnet format](https://learn.microsoft.com/dotnet/core/tools/dotnet-format)
- Unit testing setup with [xUnit](https://xunit.net/) and coverage via [coverlet](https://github.com/coverlet-coverage/coverlet)
- **GitHub Actions CI** with automatic .NET version discovery from `Directory.Build.props`

## Prerequisites

- [Docker](https://www.docker.com/) (and Docker Compose)
- VS Code with **Remote - Containers** extension

## Setup Instructions

```bash
# Clone the repo
git clone https://github.com/yogaxpto/base-cs-project.git
cd base-cs-project

```

### VS Code DevContainer

1. Open the project in VS Code.
2. Reopen in container when prompted.
3. Start coding!

## Project Structure

```bash
.
├── src/BaseCsProject/          # Main C# project
├── tests/BaseCsProject.Tests/  # xUnit test suite
├── .devcontainer/              # VS Code DevContainer setup
├── .github/workflows/          # GitHub Actions workflows
├── BaseCsProject.slnx          # Solution file
├── Directory.Build.props       # Shared MSBuild settings (target frameworks, analyzers)
├── Directory.Packages.props    # Central NuGet package versions
├── global.json                 # .NET SDK version pin
├── Dockerfile                  # Docker image definition (base / ci / dev stages)
├── docker-compose.yml          # Optional compose setup
├── Makefile                    # Shortcuts for the common commands
├── .editorconfig               # Code style rules (enforced in build)
├── .pre-commit-config.yaml     # Pre-commit hooks (whitespace, dotnet format)
├── .dockerignore
├── .gitignore
├── README.md
└── LICENSE
```

## Usage

### Run the App

```bash
# The project multi-targets, so pick the framework to run on.
dotnet run --project src/BaseCsProject --framework net10.0
```

### Run Tests

```bash
dotnet test
```

### Lint / Format Code

```bash
dotnet format BaseCsProject.slnx --verify-no-changes  # check
dotnet format BaseCsProject.slnx                      # fix
```

A `Makefile` wraps the common commands: `make lint`, `make format`, `make build`, `make test`, `make run`, `make check`.

## Continuous Integration

This project uses GitHub Actions for automated testing across multiple .NET versions. The CI pipeline:

- **Automatically discovers .NET versions** from `Directory.Build.props` (`TargetFrameworks` property)
- **Tests on every declared target framework**
- **Runs quality checks** (`dotnet format`, analyzers via `dotnet build` with warnings as errors)
- **Runs tests** (xUnit with coverage) on all discovered .NET versions
- **Restores in locked mode** on CI so `packages.lock.json` drift fails the build

### CI Workflows

Two workflows are available:

- **.NET Matrix Tests** (`.github/workflows/dotnet-matrix-test.yml`) - Multi-version testing with automatic discovery
- **CI** (`.github/workflows/dotnet-ci.yml`) - Docker-based lint, analyzer, and test jobs sharing a cached image

## Contributing

1. Fork the repo & create a new branch.
2. Write and test your changes.
3. Ensure `make check` (format, analyzers, tests) passes — it mirrors what CI runs.
4. Submit a Pull Request.

### Pre-commit hooks (optional)

`.pre-commit-config.yaml` wires whitespace fixes and `dotnet format` into `git commit`. pre-commit is a Python tool and is deliberately not part of the .NET image, so install it wherever you run `git`, alongside the `dotnet` CLI it shells out to:

```bash
pipx install pre-commit   # or: pip install pre-commit
pre-commit install
```

## License

This project is licensed under the [MIT License](LICENSE).
