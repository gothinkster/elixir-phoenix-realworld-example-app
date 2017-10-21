defmodule RealWorld.BlogTest do
  use RealWorld.DataCase

  alias RealWorld.{Blog, Repo}
  alias RealWorld.Blog.{Article, Favorite}
  alias RealWorld.Accounts.User

  import RealWorld.Factory

  @create_attrs %{body: "some body", description: "some description", title: "some title"}
  @update_attrs %{body: "some updated body", description: "some updated description", title: "some updated title"}
  @invalid_attrs %{body: nil, description: nil, title: nil}

  setup do
    user = insert(:user)
    article = insert(:article, author: user)
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    {:ok, %{author: user, article: article, jwt: jwt}}
  end

  test "list_articles/1 returns all articles" do
    assert Blog.list_articles() != []
  end

  test "get_article! returns the article with given id", %{article: article} do
    assert Blog.get_article!(article.id).id == article.id
  end

  test "create_article/1 with valid data creates a article", %{author: author} do
    assert {:ok, %Article{} = article} = Blog.create_article(Map.merge(@create_attrs, %{user_id: author.id}))
    assert article.body == "some body"
    assert article.description == "some description"
    assert article.title == "some title"
    assert article.slug == "some-title"
  end

  test "create_article/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Blog.create_article(@invalid_attrs)
  end

  test "update_article/2 with valid data updates the article", %{article: article} do
    assert {:ok, article} = Blog.update_article(article, @update_attrs)
    assert %Article{} = article
    assert article.body == "some updated body"
    assert article.description == "some updated description"
    assert article.title == "some updated title"
    assert article.slug == "some-updated-title"
  end

  test "update_article/2 with invalid data returns error changeset", %{article: article} do
    assert {:error, %Ecto.Changeset{}} = Blog.update_article(article, @invalid_attrs)
    assert article.id == Blog.get_article!(article.id).id
  end

  test "delete_article/1 deletes the article", %{article: article} do
    assert {:ok, %Article{}} = Blog.delete_article(article.slug)
    assert_raise Ecto.NoResultsError, fn -> Blog.get_article!(article.id) end
  end

  test "favorite/2 creates a new favorite with the given article", %{article: article, author: user} do
    assert {:ok, %Favorite{} = favorite} = Blog.favorite(user, article)
    favorite = Repo.preload favorite, [:article, :user]
    assert %Article{} = favorite.article
    assert %User{} = favorite.user
  end

  test "load_favorite/2 loads the favorite attribute in article", %{article: article, author: user} do

    favorite = insert(:favorite, article: article, user: user)

    article = Blog.load_favorite(user, article)
    assert article.favorited
  end
end
