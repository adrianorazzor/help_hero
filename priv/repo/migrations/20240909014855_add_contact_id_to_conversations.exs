defmodule HelpHero.Repo.Migrations.AddContactIdToConversations do
  use Ecto.Migration

  def change do
    alter table(:conversations) do
      add :contact_id, references(:contacts, on_delete: :nothing)
    end

    create index(:conversations, [:contact_id])
  end
end
