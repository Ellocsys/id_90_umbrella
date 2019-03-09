defmodule Id90.Data.Flight do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset


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
  def create_changeset(flight, _attrs) do
    flight
    # |> cast(attrs, [:name, :description, :uid, :departure, :arrive])
    |> validate_required([:name, :description, :uid, :departure, :arrive])
    |> put_duration({:departure, :arrival, :duration})
  end

  def update_changeset(flight, attrs) do
    flight
    |> cast(attrs, [:real_departure, :real_arrive])
    |> validate_required([:real_departure, :real_arrive])
    |> put_duration({:real_departure, :real_arrival, :real_duration})

  end

  def put_duration(%Changeset{} = changeset, {departure_field, arrival_field, duration_field}) do
    changeset
    |> put_change(duration_field, NaiveDateTime.diff(get_field(changeset, arrival_field), get_field(changeset, departure_field)))
  end
end
