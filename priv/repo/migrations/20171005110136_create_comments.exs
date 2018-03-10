defmodule RealWorld.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add(:body, :string)
      add(:article_id, references(:articles))
      add(:user_id, references(:users))
      timestamps(inserted_at: :created_at)
    end
  end
end
