defmodule RealWorld.BlogTest do
  use RealWorld.DataCase

  alias RealWorld.Blog
  alias RealWorld.Blog.Article

  @create_attrs %{body: "some body", description: "some description", title: "some title"}
  @update_attrs %{body: "some updated body", description: "some updated description", title: "some updated title"}
  @invalid_attrs %{body: nil, description: nil, title: nil}

  def fixture(:article, attrs \\ @create_attrs) do
    {:ok, article} = Blog.create_article(attrs)
    article
  end

  test "list_articles/1 returns all articles" do
    article = fixture(:article)
    assert Blog.list_articles() == [article]
  end

  test "get_article! returns the article with given id" do
    article = fixture(:article)
    assert Blog.get_article!(article.id) == article
  end

  test "create_article/1 with valid data creates a article" do
    assert {:ok, %Article{} = article} = Blog.create_article(@create_attrs)
    assert article.body == "some body"
    assert article.description == "some description"
    assert article.title == "some title"
    assert article.slug == "some-title"
  end

  test "create_article/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Blog.create_article(@invalid_attrs)
  end

  test "update_article/2 with valid data updates the article" do
    article = fixture(:article)
    assert {:ok, article} = Blog.update_article(article, @update_attrs)
    assert %Article{} = article
    assert article.body == "some updated body"
    assert article.description == "some updated description"
    assert article.title == "some updated title"
    assert article.slug == "some-updated-title"
  end

  test "update_article/2 with invalid data returns error changeset" do
    article = fixture(:article)
    assert {:error, %Ecto.Changeset{}} = Blog.update_article(article, @invalid_attrs)
    assert article == Blog.get_article!(article.id)
  end

  test "delete_article/1 deletes the article" do
    article = fixture(:article)
    assert {:ok, %Article{}} = Blog.delete_article(article)
    assert_raise Ecto.NoResultsError, fn -> Blog.get_article!(article.id) end
  end

  test "change_article/1 returns a article changeset" do
    article = fixture(:article)
    assert %Ecto.Changeset{} = Blog.change_article(article)
  end
end
