defmodule RealWorld.BlogTest do
  use RealWorld.DataCase

  alias RealWorld.{Blog, Repo}
  alias RealWorld.Blog.{Article, Favorite}
  alias RealWorld.Accounts.User

  import RealWorld.Factory

  @create_attrs %{body: "some body", description: "some description", title: "some title"}
  @update_attrs %{
    body: "some updated body",
    description: "some updated description",
    title: "some updated title"
  }
  @invalid_attrs %{body: nil, description: nil, title: nil}

  setup context do
    user = insert(:user)
    article = unless context[:without_article], do: insert(:article, author: user)
    {:ok, jwt, _full_claims} = RealWorldWeb.Guardian.encode_and_sign(user)
    {:ok, %{author: user, article: article, jwt: jwt}}
  end

  @tag :without_article
  test "list_articles/1 returns first 10 articles by default if no limit and offset are provided",
       %{author: user} do
    articles = insert_list(12, :article, author: user)
    actual_article_ids = Blog.list_articles(%{}) |> Enum.map(fn article -> article.id end)
    expected_article_ids = Enum.take(articles, 10) |> Enum.map(fn article -> article.id end)
    assert actual_article_ids == expected_article_ids
  end

  @tag :without_article
  test "list_articles/1 returns limited number of article provided", %{author: user} do
    articles = insert_list(3, :article, author: user)

    actual_article_ids =
      Blog.list_articles(%{"limit" => 2}) |> Enum.map(fn article -> article.id end)

    expected_article_ids = Enum.take(articles, 2) |> Enum.map(fn article -> article.id end)
    assert actual_article_ids == expected_article_ids
  end

  @tag :without_article
  test "list_articles/1 returns article after particular offset", %{author: user} do
    articles = insert_list(3, :article, author: user)

    actual_article_ids =
      Blog.list_articles(%{"offset" => 1}) |> Enum.map(fn article -> article.id end)

    expected_article_ids = Enum.take(articles, -2) |> Enum.map(fn article -> article.id end)
    assert actual_article_ids == expected_article_ids
  end

  @tag :without_article
  test "list_articles/1 returns limited number of article after particular offset", %{
    author: user
  } do
    articles = insert_list(4, :article, author: user)

    actual_article_ids =
      Blog.list_articles(%{"offset" => 1, "limit" => "2"})
      |> Enum.map(fn article -> article.id end)

    expected_article_ids = [Enum.at(articles, 1).id, Enum.at(articles, 2).id]
    assert actual_article_ids == expected_article_ids
  end

  @tag :without_article
  test "list_articles/1 returns articles filtered by particular tag", %{author: user} do
    articles_with_required_tag = insert_list(2, :article, author: user, tag_list: ["tag1"])
    insert_list(2, :article, author: user, tag_list: ["tag2"])

    actual_article_ids =
      Blog.list_articles(%{"tag" => "tag1"}) |> Enum.map(fn article -> article.id end)

    expected_article_ids = articles_with_required_tag |> Enum.map(fn article -> article.id end)
    assert actual_article_ids == expected_article_ids
  end

  test "get_article! returns the article with given id", %{article: article} do
    assert Blog.get_article!(article.id).id == article.id
  end

  test "create_article/1 with valid data creates a article", %{author: author} do
    assert {:ok, %Article{} = article} =
             Blog.create_article(Map.merge(@create_attrs, %{user_id: author.id}))

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

  test "favorite/2 creates a new favorite with the given article", %{
    article: article,
    author: user
  } do
    assert {:ok, %Favorite{} = favorite} = Blog.favorite(user, article)
    favorite = Repo.preload(favorite, [:article, :user])
    assert %Article{} = favorite.article
    assert %User{} = favorite.user
  end

  test "load_favorite/2 loads the favorite attribute in article", %{
    article: article,
    author: user
  } do
    insert(:favorite, article: article, user: user)

    article = Blog.load_favorite(article, user)
    assert article.favorited
  end

  test "load_favorite/2 returns the article without user", %{article: article} do
    article = Blog.load_favorite(article, nil)
    refute article.favorited
  end

  test "load_favorites/2 loads the favorite attribute in each article", %{
    article: article,
    author: user
  } do
    insert(:favorite, article: article, user: user)

    article = List.first(Blog.load_favorites([article], user))
    assert article.favorited
  end

  test "load_favorites/2 returns the list of articles without user", %{article: article} do
    article = List.first(Blog.load_favorites([article], nil))
    refute article.favorited
  end

  test "unfavorite/2 deletes the favorite", %{article: article, author: user} do
    insert(:favorite, article: article, user: user)
    Blog.unfavorite(article, user)

    assert length(Repo.all(Favorite)) == 0
  end
end
