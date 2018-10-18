# PlanetEx

[![CircleCI](https://circleci.com/gh/sep/planet_ex.svg?style=svg)](https://circleci.com/gh/sep/planet_ex)

PlanetEx is an Elixir application for aggregating employee and SharePoint blogs.

## Getting started

### Prerequisites

You'll need to install the following dependencies first:

- [Elixir](https://elixir-lang.org/install.html) ([version](https://github.com/mhanberg/planet/blob/master/.tool-versions))
- [Erlang](https://elixir-lang.org/install.html#installing-erlang) ([version](https://github.com/mhanberg/planet/blob/master/.tool-versions))
- [PostgreSQL](https://postgresapp.com/) 10
- [Yarn](https://yarnpkg.com/en/docs/install)
- [Node](#nodejs) ([version](https://github.com/levelhq/level/blob/master/.tool-versions))

### Installing

If you have [asdf](https://github.com/asdf-vm/asdf) installed, simply run `asdf install` in the root directory.

Run the bootstrap script to install the remaining dependencies and create your
development database:

```bash
$ cd planet
$ bin/setup
```

To run the server: `mix phx.server`.

## Running the tests, formatter, and linter

```bash
$ mix verify

==> mix format --check-formatted
==> mix credo
==> mix test.all
```

## Releasing and Deployment

PlanetEx uses [Distillery](https://github.com/bitwalker/distillery/) and [Docker](https://www.docker.com/) to build Erlang releases targeted for Ubuntu.

### Prerequisites

* Docker
* Server provisioned with the following
    * Postgres 10 
        * Can be hosted on the same machine as the release or seperately.
    * xvfb
    * Google Chrome
    * ChromeDriver

### Release

* `bin/docker-build` - builds your Docker container.
    * You only need to do this once.
* `bin/release` - builds your Distillery release.
    * Build artifacts are located in `/rel/artifacts`

### Deployment

#### Environment Variables

##### Required

* PORT
* DOMAIN
* POOL_SIZE
* SECRET_KEY_BASE
    * Can be generated using `mix phx.gen.secret`
* DATABASE_URL

##### Optional

* SHAREPOINT_CREDS
    * In order to aggregate blogs from protected SharePoint sites, you must supply credentials in the form of `username:password`

#### Deliver to remote host
* `scp rel/artifacts/<your release> user@host:/path/to/release` - Move release tar ball to the server.
* `tar -xvf /path/to/release` - unpack the release.

#### Start the server

* `/path/to/release/bin/yourapp start` - start the server in the background as a daemon
    * To stop the server - `/path/to/release/bin/yourapp stop`
or
* `/path/to/release/bin/yourapp foreground` - start the server in the foreground (analogous to `mix phx.server`)

### Database migrations

PlanetEx comes with a migration release task.

On the remote server, run `/path/to/release/bin/yourapp migrate []`

## Built With

- [Phoenix](http://phoenixframework.org/) - Web framework
- [TailwindCSS](https://tailwindcss.com/) - CSS library

## Contributors

- Mitchell Hanberg ([mhanberg](https://www.github.com/mahanberg))

---

[![Powered by SEP logo](https://raw.githubusercontent.com/sep/assets/master/images/powered-by-sep.svg)](https://www.sep.com)

PlanetEx is supported by SEP: a Software Product Design + Development company. If you'd like to [join our team](https://www.sep.com/careers/open-positions/), don't hesitate to get in touch!

