use Mix.Config

config :real_world, RealWorldWeb.Endpoint,
  load_from_system_env: true,
  http: [:inet6, port: System.get_env("PORT") || 4000],
  url: [scheme: "https", host: "https://real-world-example.herokuapp.com/", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :logger, level: :info

config :real_world, RealWorld.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true
