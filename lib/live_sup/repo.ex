defmodule LiveSup.Repo do
  use Ecto.Repo,
    otp_app: :live_sup,
    adapter: Ecto.Adapters.Postgres
end
