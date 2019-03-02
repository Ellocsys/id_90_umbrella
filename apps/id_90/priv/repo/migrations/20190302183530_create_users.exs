defmodule Id90.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :id90, :string
      add :remote_login, :string
      add :remote_pass, :string
      add :login, :string
      add :pass, :string

      timestamps()
    end

    create unique_index(:users, [:id90])
    create unique_index(:users, [:remote_login])
    create unique_index(:users, [:login])
  end
end
