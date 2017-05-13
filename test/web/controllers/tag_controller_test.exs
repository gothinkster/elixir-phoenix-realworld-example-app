defmodule RealWorld.Web.TagControllerTest do
  use RealWorld.Web.ConnCase

  alias RealWorld.Blog

  @create_attrs %{body: "some body", description: "some description", title: "some title", tag_list: ["tag1", "tag2"]}

  def fixture(:article) do
    {:ok, article} = Blog.create_article(@create_attrs)
    article
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    fixture(:article)
    conn = get conn, tag_path(conn, :index)
    assert json_response(conn, 200)["tags"] == ["tag2", "tag1"]
  end
end
