defmodule RealWorld.Blog.BlogQueries do
  import Ecto.Query, warn: false

  alias RealWorld.Accounts.UserFollower
  alias RealWorld.Blog.{Article, Comment, Favorite}

  @default_article_pagination_limit 10
  def list_articles(query \\ article_base(), params) do
    limit = params["limit"] || @default_article_pagination_limit
    offset = params["offset"] || 0

    from(article in query, limit: ^limit, offset: ^offset, order_by: article.created_at)
  end

  def feed(query \\ article_base(), user) do
    from(
      article in query,
      join: user_follower in UserFollower,
      on: article.user_id == user_follower.followee_id,
      where: user_follower.user_id == ^user.id
    )
  end

  def filter_by_tags(query \\ article_base(), tag)
  def filter_by_tags(query, nil), do: query

  def filter_by_tags(query, tag) do
    query
    |> where(
      [a],
      fragment("exists (select * from unnest(?) tag where tag = ?)", a.tag_list, ^tag)
    )
  end

  def list_comments(query \\ comment_base(), article) do
    from(comment in query, where: comment.article_id == ^article.id)
  end

  def find_favorite(query \\ favorite_base(), article, user) do
    from(f in query, where: f.article_id == ^article.id and f.user_id == ^user.id)
  end

  defp article_base, do: Article
  defp comment_base, do: Comment
  defp favorite_base, do: Favorite
end
