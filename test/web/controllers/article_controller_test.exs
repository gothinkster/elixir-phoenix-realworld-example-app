defmodule RealWorld.Web.ArticleControllerTest do
  use RealWorld.Web.ConnCase

  alias RealWorld.Blog
  alias RealWorld.Blog.Article

  @create_attrs %{body: "some body", description: "some description", title: "some title"}
  @update_attrs %{body: "some updated body", description: "some updated description", title: "some updated title"}
  @invalid_attrs %{body: nil, description: nil, title: nil}

  def fixture(:article) do
    {:ok, article} = Blog.create_article(@create_attrs)
    article
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, article_path(conn, :index)
    assert json_response(conn, 200)["articles"] == []
  end

  test "creates article and renders article when data is valid", %{conn: conn} do
    conn = post conn, article_path(conn, :create), article: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["article"]

    conn = get conn, article_path(conn, :show, id)
    json = json_response(conn, 200)["article"]

    assert json == %{
      "id" => id,
      "body" => "some body",
      "description" => "some description",
      "slug" => "some-title",
      "createdAt" => json["createdAt"],
      "updatedAt" => json["updatedAt"],
      "favoritesCount" => 0,
      "title" => "some title"}
  end

  test "does not create article and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, article_path(conn, :create), article: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen article and renders article when data is valid", %{conn: conn} do
    %Article{id: id} = article = fixture(:article)
    conn = put conn, article_path(conn, :update, article), article: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["article"]

    conn = get conn, article_path(conn, :show, id)
    json = json_response(conn, 200)["article"]

    assert json == %{
      "id" => id,
      "body" => "some updated body",
      "description" => "some updated description",
      "slug" => "some-updated-title",
      "favoritesCount" => 0,
      "createdAt" => json["createdAt"],
      "updatedAt" => json["updatedAt"],
      "title" => "some updated title"}
  end

  test "does not update chosen article and renders errors when data is invalid", %{conn: conn} do
    article = fixture(:article)
    conn = put conn, article_path(conn, :update, article), article: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen article", %{conn: conn} do
    article = fixture(:article)
    conn = delete conn, article_path(conn, :delete, article)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, article_path(conn, :show, article)
    end
  end
end
