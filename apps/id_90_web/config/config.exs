# Since configuration is shared in umbrella projects, this file
# should only configure the :id_90_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :id_90_web,
  ecto_repos: [Id90.Repo],
  generators: [context_app: :id_90]

# Configures the endpoint
config :id_90_web, Id90Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0yzbf7YskcAhE1WtUtz+VSFJfUHzt/8vwRhOD/UGtEMN7H8mD2K2yClYpW5QQJJu",
  render_errors: [view: Id90Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Id90Web.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
