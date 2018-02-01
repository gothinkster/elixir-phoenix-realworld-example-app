defmodule RealWorld.Repo.Migrations.AddUniqueIndexToFavorite do
  use Ecto.Migration

  def change do
    create(unique_index(:favorites, [:user_id, :article_id]))
  end
end
