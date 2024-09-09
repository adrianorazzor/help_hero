defmodule HelpHero.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :status, :string
      add :assigned_to_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:conversations, [:assigned_to_id])
  end
end
