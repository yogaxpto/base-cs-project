.PHONY: lint format build test run check

# The projects multi-target, so running one needs an explicit framework.
RUN_FRAMEWORK ?= net10.0

lint:
	dotnet format BaseCsProject.slnx --verify-no-changes

format:
	dotnet format BaseCsProject.slnx

build:
	dotnet build BaseCsProject.slnx

test:
	dotnet test BaseCsProject.slnx --collect:"XPlat Code Coverage"

run:
	dotnet run --project src/BaseCsProject --framework $(RUN_FRAMEWORK)

check: lint build test
