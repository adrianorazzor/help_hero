defmodule HelpHero.Conversations.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "conversations" do
    field :status, Ecto.Enum, values: [:open, :assigned, :resolved]
    belongs_to :assigned_to, HelpHero.Accounts.User
    belongs_to :contact, HelpHero.Contacts.Contact
    has_many :messages, HelpHero.Conversations.Message
    many_to_many :tags, HelpHero.Tags.Tag, join_through: "conversations_tags"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:status, :assigned_to_id, :contact_id])
    |> validate_required([:status, :contact_id])
    |> foreign_key_constraint(:assigned_to_id)
    |> foreign_key_constraint(:contact_id)
  end
end
