import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :vrumbl, Vrumbl.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "vrumbl_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :vrumbl, VrumblWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "0/Rj8N9bhOcVP54D1N+w4IqSBS4MeKyhweQ/69+RSk2hG2gIv+/LKK9YDBLBR8IB",
  server: false

# In test we don't send emails.
config :vrumbl, Vrumbl.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :pbkdf2_elixir, :rounds, 1
