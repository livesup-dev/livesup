ARG MIX_ENV="prod"

FROM hexpm/elixir:1.14.3-erlang-24.3.4.2-debian-bullseye-20210902-slim as build

RUN apt-get update && \
    apt-get install -y curl

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
    build-essential git nodejs && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN npm install npm@8.5.3 -g

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
WORKDIR /app

# set build ENV
ARG MIX_ENV
ENV MIX_ENV="${MIX_ENV}"

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# build assets
# COPY assets assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

# build project and compile
COPY priv priv
COPY assets assets
COPY lib lib

RUN mix assets.deploy

RUN mix do compile, release

# prepare release image
FROM hexpm/elixir:1.14.3-erlang-24.3.4.2-debian-bullseye-20210902-slim

# install runtime dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
    # Runtime dependencies
    build-essential ca-certificates libncurses5-dev \
    # In case someone uses `Mix.install/2` and point to a git repo
    git \
    # Additional standard tools
    wget \
    # We need it to check the state of the db server
    postgresql-client && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

ENV MIX_ENV=prod

# prepare app directory
RUN mkdir /app
WORKDIR /app

# extend hex timeout
ENV HEX_HTTP_TIMEOUT=20

# Install hex and rebar for `Mix.install/2` and Mix runtime
RUN mix local.hex --force && \
    mix local.rebar --force

# Override the default 127.0.0.1 address, so that the app
# can be accessed outside the container by binding ports
ENV LIVESUP_IP 0.0.0.0

# copy release to app container
COPY --from=build /app/_build/prod/rel/live_sup .
COPY entrypoint.sh .
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
CMD ["bash", "/app/entrypoint.sh"]