defmodule HelpHero.Repo do
  use Ecto.Repo,
    otp_app: :help_hero,
    adapter: Ecto.Adapters.Postgres
end
