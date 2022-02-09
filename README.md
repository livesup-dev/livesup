# LiveSup (Summing UP)

![Build Status](https://github.com/livesup-dev/livesup/actions/workflows/test.yml/badge.svg)

Disclaimer: it’s our first experience with LiveView so we are open to scrutiny/suggestions! Take this with a grain of salt :wink:

As you well now, we live in the Cloud era, today's applications are about connecting APIs. To manage, monitor, control your app you probably need to log in into 10 different services (or more!). It's even harder if you are new to the team or organization you work with. LiveSup tries to add transparency to the services you use and it creates a layer that organizes and simplifies the information you need when you need it.

## Goals

Besides the "business goal" mentioned above there are also a few technical goals behind this development. 

* Build a rich and dynamic application without javascript
* Build a complex and real application using LiveView that helps others to understand that there is more than a Chat or a TODOs app in this world
* Build the application using only Elixir and PostgreSQL (don’t you miss those days where applications were way much simpler?)

## Building and running Livesup localy

First let's build the image
`docker build -t livesup .`

 --pull always \

Then run the app
```
docker run --rm \
    -e DATABASE_URL=postgres://postgres:postgres@docker.for.mac.localhost:5432/livesup \
    -e PGHOST=docker.for.mac.localhost \
    -e PGPORT=5432 \
    -e PGUSER=postgres \
    -e PGPASSWORD=postgres \
    -e PGDATABASE=livesup \
    -p 8080:8080 \
    livesup
```



## Copyright and License

Copyright (c) 2021, Emiliano Jankowski.

LiveSup source code is licensed under the [MIT License](LICENSE.md).
