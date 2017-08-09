defmodule RealWorldWeb.ArticleView do
  use RealWorldWeb, :view
  alias RealWorldWeb.{ArticleView, FormatHelpers}

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
    |> Map.put(:created_at, NaiveDateTime.to_iso8601(article.created_at))
    |> Map.put(:updated_at, NaiveDateTime.to_iso8601(article.updated_at))
    |> Map.put(:favorites_count, 0)
    |> Map.take([:id, :body, :description, :title, :slug, :favorites_count, :created_at, :updated_at])
    |> FormatHelpers.camelize
  end
end
