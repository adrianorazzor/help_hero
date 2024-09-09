defmodule HelpHeroWeb.WebhookJSON do
  alias HelpHero.Webhooks.Webhook

  @doc """
  Renders a list of webhooks.
  """
  def index(%{webhooks: webhooks}) do
    %{data: for(webhook <- webhooks, do: data(webhook))}
  end

  @doc """
  Renders a single webhook.
  """
  def show(%{webhook: webhook}) do
    %{data: data(webhook)}
  end

  defp data(%Webhook{} = webhook) do
    %{
      id: webhook.id,
      message: webhook.message,
      sender: webhook.sender
    }
  end
end
