ARG DOTNET_VERSION=10.0
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_VERSION}-alpine AS base

# Alpine images ship without ICU; run with invariant globalization.
# NUGET_PACKAGES lives outside any user's home so every stage - root in CI, the
# non-root user in the dev container - resolves the same restored packages.
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 \
    DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    DOTNET_NOLOGO=1 \
    NUGET_PACKAGES=/nuget

# musl's dynamic loader searches only /lib and /usr/lib, but .NET keeps
# libhostfxr.so under host/fxr/<version>/. Managed code that P/Invokes hostfxr
# - notably the C# Dev Kit test-explorer server - therefore cannot load it, and
# fails with "Failed to find all versions of .NET Core MSBuild", which makes
# the editor's Test Explorer silently skip every test. Setting DOTNET_ROOT does
# not help: DllImport probing never consults it. The `dotnet` CLI itself is
# unaffected, since the native muxer resolves the library relative to its own
# path. Must stay in this stage: the SDK image ships exactly one host version,
# so the glob is unambiguous, and the runtimes added later are older ones.
RUN ln -s /usr/share/dotnet/host/fxr/*/libhostfxr.so /usr/lib/libhostfxr.so

WORKDIR /app

# Restore first so the NuGet layer caches independently of source changes.
COPY global.json Directory.Build.props Directory.Packages.props BaseCsProject.slnx ./
COPY src/BaseCsProject/BaseCsProject.csproj src/BaseCsProject/packages.lock.json src/BaseCsProject/
COPY tests/BaseCsProject.Tests/BaseCsProject.Tests.csproj tests/BaseCsProject.Tests/packages.lock.json tests/BaseCsProject.Tests/

# Deliberately not a `--mount=type=cache`: that cache is discarded at the end of
# the build, and the packages have to persist *in the image* so the CI jobs -
# which run against a bind-mounted checkout, not /app - restore without hitting
# the network.
RUN dotnet restore BaseCsProject.slnx --locked-mode

# CI stage: the image the workflow jobs run. Stays root on purpose - the jobs
# bind-mount the runner's checkout, which is owned by a different uid, and
# builds have to write bin/ and obj/ into it.
FROM base AS ci

# The SDK image ships only the .NET 10 runtime, but the solution multi-targets
# every framework in Directory.Build.props; install the older runtimes so
# `dotnet test` can execute all of them inside the container. bash and curl are
# prerequisites of the install script itself.
RUN apk add --no-cache bash curl \
    && curl -sSL https://dot.net/v1/dotnet-install.sh \
    | bash -s -- --channel 8.0 --runtime dotnet --install-dir /usr/share/dotnet

# Dev container stage: adds tooling the editor and CLI agents need.
# gcompat provides the glibc shim required by glibc-linked binaries
# (e.g. the Claude Code CLI), which otherwise exit immediately on musl.
FROM ci AS dev

RUN apk add --no-cache \
    gcompat \
    libstdc++ \
    ca-certificates \
    git \
    jq \
    make \
    ripgrep \
    shadow \
    sudo

# Non-root user. Tooling that refuses to run as root (e.g. the Claude Code CLI
# with --dangerously-skip-permissions, which the Dev Containers extension passes)
# needs this; `remoteUser` in devcontainer.json selects it.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN addgroup -g $USER_GID $USERNAME \
    && adduser -u $USER_UID -G $USERNAME -s /bin/bash -D $USERNAME \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && mkdir -p /home/$USERNAME/.cache /home/$USERNAME/.claude \
    && chown -R $USER_UID:$USER_GID /home/$USERNAME /app /nuget

ENV USE_BUILTIN_RIPGREP=0

USER $USERNAME
