defmodule RealWorld.Repo.Migrations.AddTaglistToArticles do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :tag_list, {:array, :string}
    end

    execute "CREATE INDEX article_tag_list_index ON articles USING GIN(tag_list)"
  end
end
