defmodule Longform.Repo do
  use Ecto.Repo,
    otp_app: :longform,
    adapter: Ecto.Adapters.Postgres
end
