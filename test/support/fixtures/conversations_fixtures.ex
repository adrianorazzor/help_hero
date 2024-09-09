defmodule HelpHero.ConversationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HelpHero.Conversations` context.
  """

  @doc """
  Generate a conversation.
  """
  def conversation_fixture(attrs \\ %{}) do
    {:ok, conversation} =
      attrs
      |> Enum.into(%{
        status: :open
      })
      |> HelpHero.Conversations.create_conversation()

    conversation
  end

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        body: "some body",
        sender: "some sender"
      })
      |> HelpHero.Conversations.create_message()

    message
  end
end
