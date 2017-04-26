defmodule RealWorld.Web.ArticleView do
  use RealWorld.Web, :view
  alias RealWorld.Web.ArticleView

  def render("index.json", %{articles: articles}) do
    %{articles: render_many(articles, ArticleView, "article.json"),
      articlesCount: length(articles)}
  end

  def render("show.json", %{article: article}) do
    %{article: render_one(article, ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
    %{id: article.id,
      createdAt: article.inserted_at |> NaiveDateTime.to_iso8601(),
      updatedAt: article.updated_at |> NaiveDateTime.to_iso8601(),
      title: article.title,
      description: article.description,
      body: article.body,
      slug: article.slug,
      favoritesCount: article.favorites_count}
  end
end
