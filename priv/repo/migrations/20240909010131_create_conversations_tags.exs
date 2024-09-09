defmodule HelpHero.Repo.Migrations.CreateConversationsTags do
  use Ecto.Migration

  def change do
    create table(:conversations_tags) do
      add :conversation_id, references(:conversations, on_delete: :delete_all)
      add :tag_id, references(:tags, on_delete: :delete_all)
    end

    create index(:conversations_tags, [:conversation_id])
    create index(:conversations_tags, [:tag_id])
    create unique_index(:conversations_tags, [:conversation_id, :tag_id])
  end
end
