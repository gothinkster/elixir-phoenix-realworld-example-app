defmodule RealWorldWeb.CommentControllerTest do
  use RealWorldWeb.ConnCase

  alias RealWorld.Blog
  alias RealWorld.Blog.Comment
  import RealWorld.Factory

  @create_attrs %{body: "some body"}
  @update_attrs %{body: "some updated body"}
  @invalid_attrs %{body: nil}

  def fixture(:comment) do
    {:ok, comment} = Blog.create_comment(@create_attrs)
    comment
  end

  setup do
    user = insert(:user)
    article = insert(:article, author: user)
    comment = insert(:comment, author: user, article: article)
    {:ok, jwt, _full_claims} = RealWorldWeb.Guardian.encode_and_sign(user)
    {:ok, %{comment: comment, user: user, article: article, jwt: jwt}}
  end

  describe "index" do
    test "lists all comments", %{conn: conn, jwt: jwt, article: article} do
      conn = conn |> put_req_header("authorization", "Token #{jwt}")
      conn = get(conn, comment_path(conn, :index), article_id: article.slug)
      assert json_response(conn, 200)["comments"] != []
    end
  end

  describe "create comment" do
    test "creates comment and renders comment when data is valid", %{
      conn: conn,
      jwt: jwt,
      article: article
    } do
      conn = conn |> put_req_header("authorization", "Token #{jwt}")
      conn = post(conn, article_comment_path(conn, :create, article.slug), comment: @create_attrs)
      json_response(conn, 201)["comment"]
    end
  end

  describe "update comment" do
    setup [:create_comment]

    test "renders comment when data is valid", %{
      conn: conn,
      jwt: jwt,
      comment: %Comment{id: id} = comment
    } do
      conn = conn |> put_req_header("authorization", "Token #{jwt}")
      conn = put(conn, comment_path(conn, :update, comment), comment: @update_attrs)
      assert %{"id" => ^id, "body" => "some updated body"} = json_response(conn, 200)["comment"]
    end

    test "renders errors when data is invalid", %{conn: conn, jwt: jwt, comment: comment} do
      conn = conn |> put_req_header("authorization", "Token #{jwt}")
      conn = put(conn, comment_path(conn, :update, comment), comment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete comment" do
    setup [:create_comment]

    test "deletes chosen comment", %{conn: conn, jwt: jwt, comment: comment} do
      conn = conn |> put_req_header("authorization", "Token #{jwt}")
      conn = delete(conn, comment_path(conn, :delete, comment))
      assert response(conn, 204)
    end
  end

  defp create_comment(_) do
    comment = fixture(:comment)
    {:ok, comment: comment}
  end
end
