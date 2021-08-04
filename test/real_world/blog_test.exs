defmodule RealWorld.BlogTest do
  use RealWorld.DataCase

  alias RealWorld.{Blogs, Repo}
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

  describe "list_articles/1" do
    @tag :without_article
    test "returns first 10 articles by default if no limit and offset are provided",
         %{author: user} do
      articles = insert_list(12, :article, author: user)
      actual_article_ids = Blogs.list_articles(%{}) |> Enum.map(fn article -> article.id end)
      expected_article_ids = Enum.take(articles, 10) |> Enum.map(fn article -> article.id end)
      assert actual_article_ids == expected_article_ids
    end

    @tag :without_article
    test "returns limited number of article provided", %{author: user} do
      articles = insert_list(3, :article, author: user)

      actual_article_ids =
        Blogs.list_articles(%{"limit" => 2}) |> Enum.map(fn article -> article.id end)

      expected_article_ids = Enum.take(articles, 2) |> Enum.map(fn article -> article.id end)
      assert actual_article_ids == expected_article_ids
    end

    @tag :without_article
    test "returns article after particular offset", %{author: user} do
      articles = insert_list(3, :article, author: user)

      actual_article_ids =
        Blogs.list_articles(%{"offset" => 1}) |> Enum.map(fn article -> article.id end)

      expected_article_ids = Enum.take(articles, -2) |> Enum.map(fn article -> article.id end)
      assert actual_article_ids == expected_article_ids
    end

    @tag :without_article
    test "returns limited number of article after particular offset", %{
      author: user
    } do
      articles = insert_list(4, :article, author: user)

      actual_article_ids =
        Blogs.list_articles(%{"offset" => 1, "limit" => "2"})
        |> Enum.map(fn article -> article.id end)

      expected_article_ids = [Enum.at(articles, 1).id, Enum.at(articles, 2).id]
      assert actual_article_ids == expected_article_ids
    end

    @tag :without_article
    test "returns articles filtered by particular tag", %{author: user} do
      articles_with_required_tag = insert_list(2, :article, author: user, tag_list: ["tag1"])
      insert_list(2, :article, author: user, tag_list: ["tag2"])

      actual_article_ids =
        Blogs.list_articles(%{"tag" => "tag1"}) |> Enum.map(fn article -> article.id end)

      expected_article_ids = articles_with_required_tag |> Enum.map(fn article -> article.id end)
      assert actual_article_ids == expected_article_ids
    end
  end

  describe "get_article!/1" do
    test "returns the article with given id", %{article: article} do
      assert Blogs.get_article!(article.id).id == article.id
    end
  end

  describe "create_article/1" do
    test "with valid data creates a article", %{author: author} do
      assert {:ok, %Article{} = article} =
               Blogs.create_article(Map.merge(@create_attrs, %{user_id: author.id}))

      assert article.body == "some body"
      assert article.description == "some description"
      assert article.title == "some title"
      assert article.slug == "some-title"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Blogs.create_article(@invalid_attrs)

      assert "can't be blank" in errors_on(changeset).title
      assert "can't be blank" in errors_on(changeset).description
      assert "can't be blank" in errors_on(changeset).body
      assert "can't be blank" in errors_on(changeset).user_id
    end
  end

  describe "update_article/2" do
    test "with valid data updates the article", %{article: article} do
      assert {:ok, article} = Blogs.update_article(article, @update_attrs)
      assert %Article{} = article
      assert article.body == "some updated body"
      assert article.description == "some updated description"
      assert article.title == "some updated title"
      assert article.slug == "some-updated-title"
    end

    test "with invalid data returns error changeset", %{article: article} do
      assert {:error, %Ecto.Changeset{} = changeset} =
               Blogs.update_article(article, @invalid_attrs)

      assert "can't be blank" in errors_on(changeset).title
      assert "can't be blank" in errors_on(changeset).description
      assert "can't be blank" in errors_on(changeset).body

      assert article.id == Blogs.get_article!(article.id).id
    end
  end

  describe "delete_article/1" do
    test "deletes the article", %{article: article} do
      assert {:ok, %Article{}} = Blogs.delete_article(article.slug)
      assert_raise Ecto.NoResultsError, fn -> Blogs.get_article!(article.id) end
    end

    test "returns false when slug does not exist" do
      assert false == Blogs.delete_article("inexistent-slug")
    end
  end

  describe "favorite/2" do
    test "creates a new favorite with the given article", %{
      article: article,
      author: user
    } do
      assert {:ok, %Favorite{} = favorite} = Blogs.favorite(user, article)
      favorite = Repo.preload(favorite, [:article, :user])
      assert %Article{} = favorite.article
      assert %User{} = favorite.user
    end
  end

  describe "load_favorite/2" do
    test "loads the favorite attribute in article", %{
      article: article,
      author: user
    } do
      insert(:favorite, article: article, user: user)

      article = Blogs.load_favorite(article, user)
      assert article.favorited
    end

    test "returns the article without user", %{article: article} do
      article = Blogs.load_favorite(article, nil)
      refute article.favorited
    end

    test "loads the favorite attribute in each article", %{
      article: article,
      author: user
    } do
      insert(:favorite, article: article, user: user)

      article = List.first(Blogs.load_favorites([article], user))
      assert article.favorited
    end

    test "returns the list of articles without user", %{article: article} do
      article = List.first(Blogs.load_favorites([article], nil))
      refute article.favorited
    end
  end

  describe "unfavorite/2" do
    test "deletes the favorite", %{article: article, author: user} do
      insert(:favorite, article: article, user: user)
      Blogs.unfavorite(article, user)

      assert length(Repo.all(Favorite)) == 0
    end
  end
end
