defmodule HelpHeroWeb.WebhookController do
  use HelpHeroWeb, :controller

  alias HelpHero.Webhooks
  alias HelpHero.Webhooks.Webhook
  alias HelpHero.Contacts
  alias HelpHero.Conversations

  action_fallback HelpHeroWeb.FallbackController

  def index(conn, _params) do
    webhooks = Webhooks.list_webhooks()
    render(conn, :index, webhooks: webhooks)
  end

  def create(conn, params) do
    # Extract WhatsApp message details from params
    message = params["Body"]
    sender = params["From"]

    # Create or update conversation
    with {:ok, contact} <- Contacts.find_or_create_by_phone(sender),
         {:ok, _conversation} <- Conversations.create_or_update_conversation(contact.id, message) do
      # Log the webhook (optional, but can be useful for debugging)
      {:ok, webhook} = Webhooks.create_webhook(%{
        message: message,
        sender: sender
      })

      conn
      |> put_status(:created)
      |> render(:show, webhook: webhook)
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(HelpHeroWeb.ChangesetJSON)
        |> render(:error, changeset: changeset)

      error ->
        require Logger
        Logger.error("Unexpected error in webhook: #{inspect(error)}")
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "An unexpected error occurred"})
    end
  end

  def show(conn, %{"id" => id}) do
    webhook = Webhooks.get_webhook!(id)
    render(conn, :show, webhook: webhook)
  end

  def update(conn, %{"id" => id, "webhook" => webhook_params}) do
    webhook = Webhooks.get_webhook!(id)

    with {:ok, %Webhook{} = webhook} <- Webhooks.update_webhook(webhook, webhook_params) do
      render(conn, :show, webhook: webhook)
    end
  end

  def delete(conn, %{"id" => id}) do
    webhook = Webhooks.get_webhook!(id)

    with {:ok, %Webhook{}} <- Webhooks.delete_webhook(webhook) do
      send_resp(conn, :no_content, "")
    end
  end
end
