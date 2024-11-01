defmodule Tiesoft.Repo do
  use Ecto.Repo,
    otp_app: :tiesoft,
    adapter: Ecto.Adapters.Postgres
end
