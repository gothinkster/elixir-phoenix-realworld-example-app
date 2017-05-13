defmodule RealWorld.Web.ArticleController do
  use RealWorld.Web, :controller

  alias RealWorld.Blog
  alias RealWorld.Blog.Article

  action_fallback RealWorld.Web.FallbackController

  def index(conn, _params) do
    articles = Blog.list_articles()
               |> RealWorld.Repo.preload(:author)
    render(conn, "index.json", articles: articles)
  end

  def create(conn, %{"article" => article_params}) do
    with {:ok, %Article{} = article} <- Blog.create_article(article_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", article_path(conn, :show, article))
      |> render("show.json", article: article)
    end
  end

  def show(conn, %{"id" => slug}) do
    article = Blog.get_article_by_slug!(slug)
    render(conn, "show.json", article: article)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = Blog.get_article!(id)

    with {:ok, %Article{} = article} <- Blog.update_article(article, article_params) do
      render(conn, "show.json", article: article)
    end
  end

  def delete(conn, %{"id" => id}) do
    article = Blog.get_article!(id)
    with {:ok, %Article{}} <- Blog.delete_article(article) do
      send_resp(conn, :no_content, "")
    end
  end
end
