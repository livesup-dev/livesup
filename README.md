# LiveSup (Summing UP)

![Build Status](https://github.com/mustela/sup/actions/workflows/elixir.yml/badge.svg)


Disclaimer: it’s my first experience with LiveView so I’m open to scrutiny/suggestions! Take this with a grain of salt :wink:

As you well now, we live in the Cloud era, today's applications are about connecting APIs. To manage, monitor, control your app you probably need to log in into 10 different services (or more!). It's even harder if you are new to the team or organization you work with. LiveSup tries to add transparency to the services you use and it creates a layer that organizes and simplifies the information you need when you need it.

## Goals

Besides the "business goal" mentioned above there are also a few technical goals behind this development. 

* Build a rich and dynamic application without javascript
* Build a complex and real application using LiveView that helps others to understand that there is more than a Chat or a TODOs app in this world
* Build the application using only Elixir and PostgreSQL (don’t you miss those days where applications were way much simpler?)

## Live DEMO

[Live demo](https://sup.gigalixirapp.com/)

To access use: emiliano@summing-up.com / Very@Safe@Password


## Development

### Running SUP using Visual Studio Code

The easiest way to start working on SUP is to use the really cool Remote - Development extension from Visual Studio Code. Make sure you have Docker installed, and then just open the project and VS Code will do the rest for you. You can see [here](https://www.youtube.com/watch?v=TfY_fxS9syo) a full video explaining this feature.

Once you have everything configured, you can run the following command in the VS Code terminal. It will install the elixir dependencis, will create the dbs and run the migrations.

```
mix setup
```

### Running the application

There are basically 2 ways to start the app, one is using the seed and the other one is adding the resources manually depending on your needs. 

#### Using the seed

The seed will create 1 project with 2 dashboards and several widgets: 

* My Stuff
    * My Dashboard
      * Weather
      * Chuck Norris Joke
      * Rollbar status page
      * Quay status page
      * Github status page
    * My Team
      * Weather
      * Chuck Norris Joke

Groups
  * Administrators
  * All Users

Users
  * emiliano@summing-up.com / `Very@Safe@Password`

Before running the seed, it's important you create an account in https://www.weatherapi.com/ and generate an API KEY, since the weather widgets will require it.

The value needs to be in an env var: WEATHER_API_KEY=xxxxx

Then you can just run `WEATHER_API_KEY=xxxxx mix sup.seeds` and it will create all the resources. 

Once it's done you can run the app using `mix phx.server` and enjoy :) 

## Copyright and License

Copyright (c) 2021, Emiliano Jankowski.

LiveSup source code is licensed under the [MIT License](LICENSE.md).
