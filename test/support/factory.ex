defmodule RealWorld.Factory do
  use ExMachina.Ecto, repo: RealWorld.Repo

  use RealWorld.{ArticleFactory, CommentFactory, FavoriteFactory, UserFactory}
end
