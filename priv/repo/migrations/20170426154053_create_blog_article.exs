defmodule RealWorld.Repo.Migrations.CreateRealWorld.Blog.Article do
  use Ecto.Migration

  def change do
    create table(:blog_articles) do
      add :title, :string
      add :description, :string
      add :body, :text
      add :slug, :string
      add :favorites_count, :integer, default: 0

      timestamps()
    end

  end
end
