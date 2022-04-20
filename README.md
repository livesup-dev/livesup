<p align="center">
  <img src="assets/static/images/logo-mid.png" height="128">
  
  <h1 align="center">LiveSup (Summing UP)</h1>
  
  <p align="center">
    We live in the Cloud era, today's applications are about connecting APIs. To manage, monitor, control your app you probably need to log in into 10 different services (or more!). It's even harder if you are new to the team or organization you work with. LiveSup tries to add transparency to the services you use and it creates a layer that organizes and simplifies the information you need when you need it.
  </p>
</p>

<p align="center">
  <a href="#">
    <img alt="Build Status" src="https://github.com/livesup-dev/livesup/actions/workflows/test.yml/badge.svg">
  </a>
</p>

---

Disclaimer: it’s our first experience with Elixir/Phoenix so we are open to scrutiny/suggestions! Take this with a grain of salt :wink:

---

## Goals

Besides the "business goal" mentioned above there are also a few technical goals behind this development. 

* Build a rich and dynamic application without javascript
* Build a complex and real application using LiveView that helps others to understand that there is more than a Chat or a TODOs app in this world
* Build the application using only Elixir and PostgreSQL (don’t you miss those days where applications were way much simpler?)

## Building and running Livesup localy

If you already have a Postgres server running you can just use the following, replacing the envs with your values

```
docker run --rm \
    -e DATABASE_URL=postgres://postgres:postgres@docker.for.mac.localhost:5432/livesup \
    -e PGHOST=docker.for.mac.localhost \
    -e PGPORT=5432 \
    -e PGUSER=postgres \
    -e PGPASSWORD=postgres \
    -e PGDATABASE=livesup \
    -p 8080:8080 \
    --pull always \
    livesup:edge
```

Or you could just do `docker-compose up` using the existing [docker-compose.yml](docker-compose.yml) file.


## Copyright and License

Copyright (c) 2021, Emiliano Jankowski.

LiveSup source code is licensed under the [MIT License](LICENSE.md).
