# Since configuration is shared in umbrella projects, this file
# should only configure the :id_90 application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :id_90, Id90.Repo,
  username: "postgres",
  password: "postgres",
  database: "id_90_dev",
  hostname: "localhost",
  pool_size: 10
