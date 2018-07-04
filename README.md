# Planet

[![CircleCI](https://circleci.com/gh/mhanberg/planet.svg?style=svg)](https://circleci.com/gh/mhanberg/planet)

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

```shell
$ cd planet
$ bin/setup
```

To run the server: `mix phx.server`.

## Running the tests

```shell
$ mix test
```

## Built With

- [Phoenix](http://phoenixframework.org/) - Web framework
- [TailwindCSS](https://tailwindcss.com/) - CSS library

## Contributors

- Mitchell Hanberg
