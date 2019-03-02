defmodule Id90.Data.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :id90, :string
    field :login, :string
    field :pass, :string
    field :remote_login, :string
    field :remote_pass, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id90, :remote_login, :remote_pass, :login, :pass])
    |> validate_required([:id90, :remote_login, :remote_pass, :login, :pass])
    |> unique_constraint(:id90)
    |> unique_constraint(:remote_login)
    |> unique_constraint(:login)
  end
end
