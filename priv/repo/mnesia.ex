
IO.inspect :mnesia.create_table(:users, [
  disc_copies: [node()],
  record_name: RealWorld.Accounts.User,
  attributes: [
    :id,
    :created_at,
    :updated_at,
    :email,
    :password,
    :username,
    :bio,
    :image
  ],
  type: :set
])

IO.inspect :mnesia.create_table(:articles, [
  disc_copies: [node()],
  record_name: RealWorld.Blog.Article,
  attributes: [
    :id,
    :created_at,
    :updated_at,
    :user_id,
    :body,
    :description,
    :title,
    :slug,
    :tag_list,
    :favorited
  ],
  type: :set
])

IO.inspect :mnesia.create_table(:favorites, [
  disc_copies: [node()],
  record_name: RealWorld.Blog.Favorite,
  attributes: [
    :id,
    :inserted_at,
    :updated_at,
    :user_id,
    :article_id
  ],
  type: :set
])

IO.inspect :mnesia.create_table(:comments, [
  disc_copies: [node()],
  record_name: RealWorld.Blog.Comment,
  attributes: [
    :id,
    :created_at,
    :updated_at,
    :user_id,
    :article_id,
    :body
  ],
  type: :set
])

IO.inspect :mnesia.create_table(:user_followers, [
  disc_copies: [node()],
  record_name: RealWorld.Accounts.UserFollower,
  attributes: [
    :id,
    :created_at,
    :user_id,
    :followee_id
  ],
  type: :set
])
