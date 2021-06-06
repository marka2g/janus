defmodule Janus.Repo do
  use Ecto.Repo,
    otp_app: :janus,
    adapter: Ecto.Adapters.Postgres
end
