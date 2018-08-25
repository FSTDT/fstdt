# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :fstdt,
  ecto_repos: [Fstdt.Repo],
  submission_queue_path: "./submission_queue.term"

# Configures the endpoint
config :fstdt, FstdtWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aoffVIAvKtaXRz3GXcLhDl9QyxCikMIC+Q2g78xD4Z4NHoQ2Y5ZorRIx25JUihHB",
  render_errors: [view: FstdtWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Fstdt.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
