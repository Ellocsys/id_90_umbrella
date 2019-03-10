defmodule Id90.Data.Flight do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset
  alias Id90.Data

  schema "flights" do
    field :arrive, :naive_datetime
    field :departure, :naive_datetime
    field :description, :string
    field :duration, :integer, default: 0
    field :name, :string
    field :real_arrive, :naive_datetime
    field :real_departure, :naive_datetime
    field :real_duration, :integer, default: 0
    field :uid, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def create_changeset(flight, attrs) do
    flight
    |> cast(attrs, [:name, :description, :uid, :departure, :arrive])
    |> validate_required([:name, :description, :uid, :departure, :arrive])
    |> put_duration({:departure, :arrive, :duration})
  end

  def update_changeset(flight) do
    flight
    |> Data.add_board_data()
    # |> validate_required([:real_departure, :real_arrive])
    |> put_duration({:real_departure, :real_arrive, :real_duration})
  end

  def put_duration(%Changeset{} = changeset, {departure_field, arrive_field, duration_field}) do
    changeset
    |> put_change(
      duration_field,
      NaiveDateTime.diff(
        get_field(changeset, arrive_field),
        get_field(changeset, departure_field)
      )
    )
  end
end
