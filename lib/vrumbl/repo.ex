defmodule Vrumbl.Repo do
  use Ecto.Repo,
    otp_app: :vrumbl,
    adapter: Ecto.Adapters.Postgres
end
