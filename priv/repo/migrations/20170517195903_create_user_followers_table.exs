defmodule RealWorld.Repo.Migrations.CreateUserFollowersTable do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:user_followers, primary_key: false) do
      add(:user_id, references(:users), primary_key: true)
      add(:follower_id, references(:users), primary_key: true)

      timestamps(updated_at: false)
    end

    create(index(:user_followers, [:user_id]))
    create(index(:user_followers, [:follower_id]))
    # create unique_index(:user_followers, [:user_id, :follower_id])
  end
end
