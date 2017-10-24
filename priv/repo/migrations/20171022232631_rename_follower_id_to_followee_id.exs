defmodule RealWorld.Repo.Migrations.RenameFollowerIdToFolloweeId do
  use Ecto.Migration

  def change do
    rename table(:user_followers), :follower_id, to: :followee_id
    drop index(:user_followers, [:follower_id])
    create index(:user_followers, [:followee_id])
  end
end
