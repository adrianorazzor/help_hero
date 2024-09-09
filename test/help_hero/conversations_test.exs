defmodule HelpHero.ConversationsTest do
  use HelpHero.DataCase

  alias HelpHero.Conversations

  describe "conversations" do
    alias HelpHero.Conversations.Conversation

    import HelpHero.ConversationsFixtures

    @invalid_attrs %{status: nil}

    test "list_conversations/0 returns all conversations" do
      conversation = conversation_fixture()
      assert Conversations.list_conversations() == [conversation]
    end

    test "get_conversation!/1 returns the conversation with given id" do
      conversation = conversation_fixture()
      assert Conversations.get_conversation!(conversation.id) == conversation
    end

    test "create_conversation/1 with valid data creates a conversation" do
      valid_attrs = %{status: :open}

      assert {:ok, %Conversation{} = conversation} = Conversations.create_conversation(valid_attrs)
      assert conversation.status == :open
    end

    test "create_conversation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Conversations.create_conversation(@invalid_attrs)
    end

    test "update_conversation/2 with valid data updates the conversation" do
      conversation = conversation_fixture()
      update_attrs = %{status: :assigned}

      assert {:ok, %Conversation{} = conversation} = Conversations.update_conversation(conversation, update_attrs)
      assert conversation.status == :assigned
    end

    test "update_conversation/2 with invalid data returns error changeset" do
      conversation = conversation_fixture()
      assert {:error, %Ecto.Changeset{}} = Conversations.update_conversation(conversation, @invalid_attrs)
      assert conversation == Conversations.get_conversation!(conversation.id)
    end

    test "delete_conversation/1 deletes the conversation" do
      conversation = conversation_fixture()
      assert {:ok, %Conversation{}} = Conversations.delete_conversation(conversation)
      assert_raise Ecto.NoResultsError, fn -> Conversations.get_conversation!(conversation.id) end
    end

    test "change_conversation/1 returns a conversation changeset" do
      conversation = conversation_fixture()
      assert %Ecto.Changeset{} = Conversations.change_conversation(conversation)
    end
  end

  describe "messages" do
    alias HelpHero.Conversations.Message

    import HelpHero.ConversationsFixtures

    @invalid_attrs %{body: nil, sender: nil}

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Conversations.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Conversations.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{body: "some body", sender: "some sender"}

      assert {:ok, %Message{} = message} = Conversations.create_message(valid_attrs)
      assert message.body == "some body"
      assert message.sender == "some sender"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Conversations.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      update_attrs = %{body: "some updated body", sender: "some updated sender"}

      assert {:ok, %Message{} = message} = Conversations.update_message(message, update_attrs)
      assert message.body == "some updated body"
      assert message.sender == "some updated sender"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Conversations.update_message(message, @invalid_attrs)
      assert message == Conversations.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Conversations.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Conversations.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Conversations.change_message(message)
    end
  end
end
