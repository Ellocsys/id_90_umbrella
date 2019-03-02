# Since configuration is shared in umbrella projects, this file
# should only configure the :id_90 application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :id_90,
  ecto_repos: [Id90.Repo]

import_config "#{Mix.env()}.exs"
