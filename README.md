# fstdt
Fundies Say the Darndest Things! Website

## Running a local instance in dev mode

To run this app, you'll need to install [Elixir] and [PostgreSQL].
The rest of it will be installed by the mix tool.

[Elixir]: https://elixir-lang.org/
[PostgreSQL]: https://postgresql.org/

After that, enter enough details into the [config/dev.exs] file for the app to log into your postgresql server,
then run these commands to start it up:

    # Download all of the Erlang and Elixir dependencies
    mix deps.get
    # Create the database
    mix ecto.create
    # Create the database tables
    mix ecto.migrate
    # Start the webserver on http://localhost:4000/
    mix phx.server

As an alternative, you might also like to use this mode:

    iex -S phx.server # on UNIX-likes
    iex.bat --werl -S phx.server # in Windows Powershell
