defmodule Id90.Data.Flight do
  use Ecto.Schema
  import Ecto.Changeset


  schema "flights" do
    field :arrive, :naive_datetime
    field :departure, :naive_datetime
    field :description, :string
    field :duration, :integer
    field :name, :string
    field :real_arrive, :naive_datetime
    field :real_departure, :naive_datetime
    field :real_duration, :integer
    field :uid, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(flight, attrs) do
    flight
    |> cast(attrs, [:name, :description, :uid, :departure, :arrive, :real_departure, :real_arrive, :duration, :real_duration])
    |> validate_required([:name, :description, :uid, :departure, :arrive, :real_departure, :real_arrive, :duration, :real_duration])
  end
end
