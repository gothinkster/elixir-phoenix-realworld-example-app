defmodule RealWorld.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :string
      add :email, :string
      add :bio, :string
      add :image, :string

      timestamps inserted_at: :created_at
    end

    create unique_index(:users, [:username])
  end
end
