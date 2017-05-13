defmodule RealWorld.Web.ArticleView do
  use RealWorld.Web, :view
  alias RealWorld.Web.{ArticleView, FormatHelpers, UserView}

  def render("index.json", %{articles: articles}) do
    %{articles: render_many(articles, ArticleView, "article.json"),
      articlesCount: length(articles)}
  end

  def render("show.json", %{article: article}) do
    %{article: render_one(article, ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
    article
    |> Map.from_struct
    |> Map.put(:created_at, datetime_to_iso8601(article.created_at))
    |> Map.put(:updated_at, datetime_to_iso8601(article.updated_at))
    |> Map.put(:favorites_count, 0)
    |> Map.put(:favorited, false)
    |> Map.take([:id, :body, :description, :title, :slug, :favorites_count, :favorited, :author, :tag_list, :created_at, :updated_at])
    |> Map.put(:author, UserView.render("author.json", user: article.author))
    |> FormatHelpers.camelize
  end

  defp datetime_to_iso8601(datetime) do
    datetime
    |> Map.put(:microsecond, {elem(datetime.microsecond, 0), 3})
    |> DateTime.to_iso8601
  end

end
