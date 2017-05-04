defmodule RealWorld.Repo.Migrations.CreateRealWorld.Blog.Article do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string
      add :description, :string
      add :body, :text
      add :slug, :string

      timestamps inserted_at: :created_at
    end

    create unique_index(:articles, [:slug])
  end
end
