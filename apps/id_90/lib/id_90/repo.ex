defmodule Id90.Repo do
  use Ecto.Repo,
    otp_app: :id_90,
    adapter: Ecto.Adapters.Postgres
end
