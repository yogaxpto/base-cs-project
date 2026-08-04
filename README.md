# base-python-project

![Python Version](https://img.shields.io/badge/python-3.11%2B-blue)
![License: MIT](https://img.shields.io/badge/license-MIT-green)

## Overview

This repository is a **base template for Python projects** with a containerized development workflow. It provides a structured scaffold for Python applications, including Docker and VS Code Dev Container configuration for easy setup.

### Key Features

- **Python 3.11+ support** with automatic multi-version CI testing
- Dockerized development with `Dockerfile` and `docker-compose.yml`
- [uv](https://pypi.org/project/uv/) for fast dependency management
- Linting with [ruff](https://github.com/astral-sh/ruff) and type checking with [mypy](https://mypy-lang.org/)
- Unit testing setup with [pytest](https://docs.pytest.org/)
- **GitHub Actions CI** with automatic Python version discovery (currently tests 3.11, 3.12, 3.13, 3.14)

## Prerequisites

- [Docker](https://www.docker.com/) (and Docker Compose)
- VS Code with **Remote - Containers** extension

## Setup Instructions

```bash
# Clone the repo
git clone https://github.com/yogaxpto/base-python-project.git
cd base-python-project

```

### VS Code DevContainer

1. Open the project in VS Code.
2. Reopen in container when prompted.
3. Start coding!

## Project Structure

```bash
.
├── base_python_project/   # Main Python package
├── tests/                    # Pytest test suite
├── .devcontainer/            # VS Code DevContainer setup
├── .github/workflows/        # GitHub Actions workflows
├── Dockerfile                # Docker image definition
├── docker-compose.yml        # Optional compose setup
├── pyproject.toml            # Python dependencies and config
├── uv.lock                   # Lockfile from uv
├── ruff.toml                 # Ruff linter config
├── .gitignore
├── README.md
└── LICENSE
```

## Usage

### Run the App

```bash
python -m base_python_project
```

### Run Tests

```bash
pytest
```

### Lint Code

```bash
ruff check .
```

## Continuous Integration

This project uses GitHub Actions for automated testing across multiple Python versions. The CI pipeline:

- **Automatically discovers Python versions** from `pyproject.toml` (`requires-python` field)
- **Tests on all stable Python versions** from the minimum onward
- **Runs quality checks** (ruff, mypy) on the latest Python version
- **Runs tests** (pytest with coverage) on all discovered Python versions

The workflow uses [snok/latest-python-versions](https://github.com/snok/latest-python-versions) for dynamic version discovery, ensuring zero maintenance for version management.

### CI Workflow

Two workflows are available:

- **Python Matrix Tests** (`.github/workflows/python-matrix-test.yml`) - Multi-version testing with automatic discovery
- **Test** (`.github/workflows/python-test.yml`) - Docker-based single-version testing

## Contributing

1. Fork the repo & create a new branch.
2. Write and test your changes.
3. Ensure `ruff` and `pytest` pass.
4. Submit a Pull Request.

## License

This project is licensed under the [MIT License](LICENSE).
