ARG MIX_ENV="prod"

FROM elixir:1.13.2 as build

RUN apt-get update && \
  apt-get install -y postgresql-client nodejs

RUN mix local.hex --force \
  && mix archive.install --force hex phx_new 1.6.6 \
  && apt-get update \
  && curl -sL https://deb.nodesource.com/setup_14.x | bash \
  && apt-get install -y apt-utils \
  && apt-get install -y nodejs \
  && apt-get install -y build-essential \
  && apt-get install -y inotify-tools \
  && mix local.rebar --force

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
WORKDIR /app

# install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# set build ENV
ARG MIX_ENV
ENV MIX_ENV="${MIX_ENV}"

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# build assets
COPY assets assets
RUN cd assets && npm install && npm run deploy
RUN mix phx.digest

# build project and compile
COPY priv priv
COPY lib lib
RUN mix do compile, release livesup

# prepare release image
FROM alpine:3.14.2 AS app

# install runtime dependencies
RUN apk add --update bash openssl postgresql-client

EXPOSE 4000
ENV MIX_ENV=prod

# prepare app directory
RUN mkdir /app
WORKDIR /app

# copy release to app container
COPY --from=build /app/_build/prod/rel/livesup .
COPY entrypoint.sh .
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
CMD ["bash", "/app/entrypoint.sh"]