defmodule Plax.Repo do
  use Ecto.Repo,
    otp_app: :plax,
    adapter: Ecto.Adapters.Postgres
end
