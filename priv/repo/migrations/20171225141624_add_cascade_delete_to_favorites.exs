defmodule RealWorld.Repo.Migrations.AddCascadeDeleteToFavorites do
  use Ecto.Migration

  def up do
    execute("ALTER TABLE favorites DROP CONSTRAINT favorites_article_id_fkey")

    alter table(:favorites) do
      modify(:article_id, references(:articles, on_delete: :delete_all))
    end
  end

  def down do
    execute("ALTER TABLE favorites DROP CONSTRAINT favorites_article_id_fkey")

    alter table(:favorites) do
      modify(:article_id, references(:articles))
    end
  end
end
