defmodule HelpHero.Conversations.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :body, :string
    field :sender, :string
    belongs_to :conversation, HelpHero.Conversations.Conversation

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :sender])
    |> validate_required([:body, :sender])
  end
end
