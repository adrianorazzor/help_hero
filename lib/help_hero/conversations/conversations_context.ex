defmodule HelpHero.Conversations do
  alias HelpHero.Conversations.Message
  @moduledoc """
  The Conversations context.
  """

  import Ecto.Query, warn: false
  alias HelpHero.Repo

  alias HelpHero.Conversations.Conversation

  def subscribe do
    Phoenix.PubSub.subscribe(HelpHero.PubSub, "conversations")
  end

  def broadcast({:ok, conversation}, event) do
    Phoenix.PubSub.broadcast(HelpHero.PubSub, "conversations", {event, conversation})
    {:ok, conversation}
  end

  def broadcast({:error, _reason} = error, _event), do: error

  def create_message(%Conversation{} = conversation, attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:conversation, conversation)
    |> Repo.insert()
  end

  def create_or_update_conversation(contact_id, message_body) do
    conversation =
      Conversation
      |> where([c], c.contact_id == ^contact_id and c.status != :resolved)
      |> order_by([c], desc: c.inserted_at)
      |> limit(1)
      |> Repo.one()

    conversation =
      case conversation do
        nil -> create_conversation(%{status: :open, contact_id: contact_id})
        conversation -> {:ok, conversation}
      end

    with {:ok, conversation} <- conversation,
         {:ok, _message} <- create_message(conversation, %{body: message_body, sender: "customer"}) do
      broadcast({:ok, conversation}, :conversation_updated)
    else
      error -> error
    end
  end

  def list_conversations do
    Repo.all(Conversation)
  end

  def get_conversation!(id), do: Repo.get!(Conversation, id)

  def create_conversation(attrs \\ %{}) do
    %Conversation{}
    |> Conversation.changeset(attrs)
    |> Repo.insert()
  end

  def update_conversation(%Conversation{} = conversation, attrs) do
    conversation
    |> Conversation.changeset(attrs)
    |> Repo.update()
  end

  def delete_conversation(%Conversation{} = conversation) do
    Repo.delete(conversation)
  end

  def change_conversation(%Conversation{} = conversation, attrs \\ %{}) do
    Conversation.changeset(conversation, attrs)
  end

  alias HelpHero.Conversations.Message

  def list_messages do
    Repo.all(Message)
  end

  def get_message!(id), do: Repo.get!(Message, id)


  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
