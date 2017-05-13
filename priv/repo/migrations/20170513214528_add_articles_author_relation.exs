defmodule RealWorld.Repo.Migrations.AddArticlesAuthorRelation do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :user_id, references(:users)
    end
  end
end
