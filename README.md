# fstdt
Fundies Say the Darndest Things! Website

## Running a local instance in dev mode

To run this app, you'll need to install [Elixir] and [PostgreSQL] for the app.
You also need [NodeJS] to build the assets,
though Node's not used when the app's running.
The rest of it will be installed by the mix tool.

[Elixir]: https://elixir-lang.org/
[PostgreSQL]: https://postgresql.org/
[NodeJS]: https://nodejs.org/

You're going to need a C compiler for some of the deps, too.
On Windows with Chocolatey:

    choco install visualcpp-build-tools
    choco install microsoft-build-tools --version 14.0.25420.1

On Ubuntu, it's more like this:

    apt install build-essential

After that, enter enough details into the [config/dev.exs] file for the app to log into your postgresql server,
then run these commands to start it up:

    # Download all of the Erlang and Elixir dependencies
    mix deps.get
    # Build the assets
    cd assets
    npm install
    cd ..
    # Create the database
    mix ecto.create
    # Create the database tables
    mix ecto.migrate
    # Start the webserver on http://localhost:4000/
    mix phx.server

As an alternative, you might also like to run it with a REPL:

    iex -S phx.server # on UNIX-likes
    iex.bat --werl -S phx.server # in Windows Powershell

[config/dev.exs]: https://github.com/FSTDT/fstdt/blob/master/config/dev.exs
