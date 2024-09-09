defmodule HelpHero.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :text
      add :sender, :string
      add :conversation_id, references(:conversations, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:conversation_id])
  end
end
