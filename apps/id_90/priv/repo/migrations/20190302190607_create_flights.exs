defmodule Id90.Repo.Migrations.CreateFlights do
  use Ecto.Migration

  def change do
    create table(:flights) do
      add :name, :string
      add :description, :string
      add :uid, :string
      add :departure, :naive_datetime
      add :arrive, :naive_datetime
      add :real_departure, :naive_datetime
      add :real_arrive, :naive_datetime
      add :duration, :integer
      add :real_duration, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:flights, [:user_id])
  end
end
