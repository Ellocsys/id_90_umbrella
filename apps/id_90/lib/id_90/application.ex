defmodule Id90.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Id90.Repo,
      {Id90.Updater, [60]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Id90.Supervisor)
  end
end
