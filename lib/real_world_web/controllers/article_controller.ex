defmodule RealWorldWeb.ArticleController do
  use RealWorldWeb, :controller
  use RealWorldWeb.GuardedController

  alias RealWorld.{Blog, Repo}
  alias RealWorld.Blog.{Article, Favorite}

  action_fallback(RealWorldWeb.FallbackController)

  plug(
    Guardian.Plug.EnsureAuthenticated
    when action in [
           :create,
           :update,
           :delete,
           :favorite
         ]
  )

  def index(conn, params, user) do
    articles =
      Blog.list_articles(params)
      |> Repo.preload([:author, :favorites])
      |> Blog.load_favorites(user)

    render(conn, "index.json", articles: articles)
  end

  def feed(conn, _params, user) do
    articles =
      user
      |> Blog.feed()
      |> Repo.preload([:author, :favorites])

    render(conn, "index.json", articles: articles)
  end

  def create(conn, %{"article" => params}, user) do
    with {:ok, %Article{} = article} <- Blog.create_article(create_params(params, user)) do
      article =
        article
        |> Repo.preload([:author, :favorites])

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.article_path(conn, :show, article))
      |> render("show.json", article: article)
    end
  end

  defp create_params(params, user) do
    params
    |> Map.merge(%{"user_id" => user.id})
  end

  def show(conn, %{"id" => slug}, user) do
    article =
      slug
      |> Blog.get_article_by_slug!()
      |> Repo.preload([:author, :favorites])
      |> Blog.load_favorite(user)

    render(conn, "show.json", article: article)
  end

  def update(conn, %{"id" => id, "article" => article_params}, user) do
    article =
      id
      |> Blog.get_article!()
      |> Repo.preload([:author, :favorites])
      |> Blog.load_favorite(user)

    with {:ok, %Article{} = article} <- Blog.update_article(article, article_params) do
      render(conn, "show.json", article: article)
    end
  end

  def favorite(conn, %{"slug" => slug}, user) do
    article =
      slug
      |> Blog.get_article_by_slug!()

    with {:ok, %Favorite{}} <- Blog.favorite(user, article) do
      article =
        article
        |> Repo.preload([:author, :favorites])
        |> Blog.load_favorite(user)

      render(conn, "show.json", article: Blog.load_favorite(article, user))
    end
  end

  def unfavorite(conn, %{"slug" => slug}, user) do
    article =
      slug
      |> Blog.get_article_by_slug!()

    with {:ok, _} <- Blog.unfavorite(article, user) do
      article =
        article
        |> Repo.preload([:author, :favorites])
        |> Blog.load_favorite(user)

      render(conn, "show.json", article: Blog.load_favorite(article, user))
    end
  end

  def delete(conn, %{"id" => slug}, _user) do
    Blog.delete_article(slug)
    send_resp(conn, :no_content, "")
  end
end
