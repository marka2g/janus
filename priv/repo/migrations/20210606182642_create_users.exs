defmodule Janus.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string
      add :wordpress_id, :string
      add :email, :string, null: false
      add :password_hash, :string
      add :is_active, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
