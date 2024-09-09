defmodule HelpHero.WebhooksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HelpHero.Webhooks` context.
  """

  @doc """
  Generate a webhook.
  """
  def webhook_fixture(attrs \\ %{}) do
    {:ok, webhook} =
      attrs
      |> Enum.into(%{
        message: "some message",
        sender: "some sender"
      })
      |> HelpHero.Webhooks.create_webhook()

    webhook
  end
end
