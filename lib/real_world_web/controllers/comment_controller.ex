defmodule RealWorldWeb.CommentController do
  use RealWorldWeb, :controller
  use Guardian.Phoenix.Controller

  alias RealWorld.Blog
  alias RealWorld.Blog.Comment

  action_fallback RealWorldWeb.FallbackController

  plug Guardian.Plug.EnsureAuthenticated, %{handler: RealWorldWeb.SessionController} when action in [:create, :update, :delete]

  def index(conn, %{"article" => slug}, _user, _full_claims) do
    article = Blog.get_article_by_slug!(slug)
    comments = Blog.list_comments(article)
    |> RealWorld.Repo.preload(:author)
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"article" => slug, "comment" => comment_params}, user, _full_claims) do
    article = Blog.get_article_by_slug!(slug)
    with {:ok, %Comment{} = comment} <- Blog.create_comment(comment_params |> Map.merge(%{"user_id" => user.id}) |> Map.merge(%{"article_id" => article.id})) do
      conn
      |> put_status(:created)
      |> render("show.json", comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Blog.get_comment!(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Blog.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Blog.update_comment(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}, _user, _full_claims) do
    comment = Blog.get_comment!(id)
    with {:ok, %Comment{}} <- Blog.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
