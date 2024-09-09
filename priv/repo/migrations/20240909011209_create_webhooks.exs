defmodule HelpHero.Repo.Migrations.CreateWebhooks do
  use Ecto.Migration

  def change do
    create table(:webhooks) do
      add :message, :string
      add :sender, :string

      timestamps(type: :utc_datetime)
    end
  end
end
