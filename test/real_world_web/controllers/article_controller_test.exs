defmodule RealWorldWeb.ArticleControllerTest do
  use RealWorldWeb.ConnCase

  import RealWorld.Factory

  @create_attrs %{body: "some body", description: "some description", title: "some title"}
  @update_attrs %{body: "some updated body", description: "some updated description", title: "some updated title"}
  @invalid_attrs %{body: nil, description: nil, title: nil}

  setup do
    user = insert(:user)
    article = insert(:article, author: user)
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    {:ok, %{article: article, user: user, jwt: jwt}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, article_path(conn, :index)
    assert json_response(conn, 200)["articles"] != []
  end

  test "creates article and renders article when data is valid", %{conn: conn, jwt: jwt} do
    conn = conn |> put_req_header("authorization", "Token #{jwt}")
    conn = post conn, article_path(conn, :create), article: @create_attrs
    json = json_response(conn, 201)["article"]

    assert json == %{
      "id" => json["id"],
      "body" => "some body",
      "description" => "some description",
      "slug" => "some-title",
      "createdAt" => json["createdAt"],
      "updatedAt" => json["updatedAt"],
      "favoritesCount" => 0,
      "title" => "some title",
      "author" => %{},
      "favorited" => false,
      "tagList" => nil}
  end

  test "does not create article and renders errors when data is invalid", %{conn: conn, jwt: jwt} do
    conn = conn |> put_req_header("authorization", "Token #{jwt}")
    conn = post conn, article_path(conn, :create), article: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen article and renders article when data is valid", %{conn: conn, jwt: jwt, article: article} do
    article_id = article.id
    conn = conn |> put_req_header("authorization", "Token #{jwt}")
    conn = put conn, article_path(conn, :update, article), article: @update_attrs
    assert %{"id" => ^article_id} = json_response(conn, 200)["article"]

    conn = get conn, article_path(conn, :show, "some-updated-title")
    json = json_response(conn, 200)["article"]

    assert json == %{
      "id" => article_id,
      "body" => "some updated body",
      "description" => "some updated description",
      "slug" => "some-updated-title",
      "favoritesCount" => 0,
      "createdAt" => json["createdAt"],
      "updatedAt" => json["updatedAt"],
      "title" => "some updated title",
      "author" => %{"bio" => "some bio", "image" => "some image", "username" => "john"},
      "favorited" => false,
      "tagList" => ["tag1", "tag2"]
    }
  end

  test "favorites the chosen article", %{conn: conn, jwt: jwt, article: article} do
    article_id = article.id
    conn = conn |> put_req_header("authorization", "Token #{jwt}")
    conn = post conn, article_path(conn, :favorite, article)
    assert %{"id" => ^article_id, "favorited" => true} = json_response(conn, 200)["article"]
  end

  test "returns the chosen article when is favorited by the user", %{conn: conn, jwt: jwt, article: article, user: user} do
    insert(:favorite, user: user, article: article)
    conn = conn |> put_req_header("authorization", "Token #{jwt}")
    conn = get conn, article_path(conn, :show, article.slug)
    json = json_response(conn, 200)["article"]

    assert json == %{
      "id" => article.id,
      "body" => "some body",
      "description" => "some description",
      "slug" => "some-tile",
      "favoritesCount" => 0,
      "createdAt" => json["createdAt"],
      "updatedAt" => json["updatedAt"],
      "title" => "some title",
      "author" => %{
        "bio" => "some bio",
        "image" => "some image",
        "username" => "john"
      },
      "favorited" => true,
      "tagList" => ["tag1", "tag2"]
    }
  end

  test "deletes the given article favorited by the user", %{conn: conn, jwt: jwt, article: article, user: user} do
    insert(:favorite, user: user, article: article)

    conn = conn |> put_req_header("authorization", "Token #{jwt}")
    conn = delete conn, article_path(conn, :unfavorite, article)
    assert response(conn, 204)
  end

  test "does not update chosen article and renders errors when data is invalid",
                                                      %{conn: conn, jwt: jwt, article: article} do
    conn = conn |> put_req_header("authorization", "Token #{jwt}")
    conn = put conn, article_path(conn, :update, article), article: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen article", %{conn: conn, jwt: jwt, article: article} do
    conn = conn |> put_req_header("authorization", "Token #{jwt}")
    conn = delete conn, article_path(conn, :delete, article)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, article_path(conn, :show, article)
    end
  end
end
