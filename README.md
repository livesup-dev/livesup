<p align="center">
  <img src="docs/images/flow.png" width="500">
  
  <h1 align="center">LiveSup (Summing UP)</h1>
  
  <p align="center">
    We live in the Cloud era, today's applications are about connecting APIs. To manage, monitor, control your app, teams and business you probably need to log in into 10 different services (or more!). It's even harder if you just joined the organization or switched to a new team. LiveSup tries to add transparency to the services you use and it creates a layer that organizes and simplifies the information you need when you need it.
  </p>
</p>

<p align="center">
  <a href="#">
    <img alt="Build Status" src="https://github.com/livesup-dev/livesup/actions/workflows/test.yml/badge.svg">
  </a>
  <a href="https://codecov.io/gh/livesup-dev/livesup">
    <img src="https://codecov.io/gh/livesup-dev/livesup/branch/main/graph/badge.svg?token=7XTN1OEUHY"/>
  </a>
  <a href="https://github.com/livesup-dev/l/commits/master">
    <img src="https://img.shields.io/github/last-commit/livesup-dev/livesup.svg"/>
  </a>
</p>

---

Disclaimer: it’s our first experience with Elixir/Phoenix so we are open to scrutiny/suggestions! Take this with a grain of salt :wink:

---

:warning: Join our community on [Slack](https://join.slack.com/t/livesup-community/shared_invite/zt-1f6hn8log-QrrgQfaTpunxxMXf9U8MuA) if you have questions, or just to say hi 🎉.


---

**Table of Contents**

1. [What is Livesup?](##what-is-livesu)
1. [Business Goals](#business-goals)
1. [Technical Goals](#technical-goals)
1. [Public Roadmap](#public-roadmap)
1. [Running Livesup localy](#running-livesup-localy)
1. [Developer Guide](/docs/develop/guide.md)
1. [Contributing](/docs/contributing.md)
1. [Code of Conduct](/docs/code_of_conduct.md)

## What is Livesup?

![](/docs/images/dashboard-full.png)

Livesup is an application that lets you concentrate information from different services or datastores in a dashboard, it's a jumping off point. The information is displayed with predefined widgets. Each widget is responsible for reading and displaying the data correctly. For instance the `Github Pull Requests` widget will fetch the last n open/close pull requests from a repository and will display accordingly.

## What is it not?

Livesup is NOT meant to replace any of the datasources it consumes. It is not meant to be used as a debugging tool or an advanced troubleshooting service.

## Business Goals

* Have fun!
* Add transparency to the existing services in your organization/team
* Remove the need to access several services to have a sense of what's going on with your business/app/teams.
* Help onboarding people to the team/organization.
* Drive meetings exposing data that was not available before (easily). 

## Technical Goals

Besides the "business goal" mentioned above there are also a few technical goals behind this development. 

* Have fun!
* Learn Elixir
* Build a rich and dynamic application without javascript (or as little as possible)
* Build a more "complex" and "real" application that helps others understand that you can do much more than just a chat or a ToDo app with a Elixir/phoenix :)

## Public roadmap

Our [product roadmap](https://github.com/orgs/livesup-dev/projects/2) is where you can learn about what features we're working on, what stage they're in, and when we expect to bring them to you. Have any questions or comments about items on the roadmap? Share your feedback via Livesup public discussions.

## Running Livesup localy

If you already have a Postgres server running you can just use the following, replacing the envs with your values

For the `GUARDIAN_SECRET` env var if you have elixir/phoenix running locally you can generate a new key using `mix phx.gen.secret`

```
docker run --rm \
    -e DATABASE_URL=postgres://postgres:postgres@docker.for.mac.localhost:5432/livesup \
    -e PGHOST=docker.for.mac.localhost \
    -e PGPORT=5432 \
    -e PGUSER=postgres \
    -e PGPASSWORD=postgres \
    -e PGDATABASE=livesup \
    -e GUARDIAN_SECRET=your-secret \
    -p 8080:8080 \
    --pull always \
    livesup:edge
```

Or you could just do `docker-compose up` using the existing [docker-compose.yml](docker-compose.yml) file.


## Copyright and License

Copyright (c) 2021, Emiliano Jankowski.

LiveSup source code is licensed under the [MIT License](LICENSE.md).
