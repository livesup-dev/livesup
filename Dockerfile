FROM elixir:1.13.2

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
# RUN mkdir /app
# COPY . /app
WORKDIR /app

COPY mix.exs .
COPY mix.lock .

RUN mkdir assets
COPY assets/package.json assets

RUN mix deps.get
# Compile the project
RUN mix do compile

# RUN npm install
RUN cd assets && \
    npm install

EXPOSE 4000

CMD ["/app/entrypoint.sh"]