defmodule HelpHero.Webhooks.Webhook do
  use Ecto.Schema
  import Ecto.Changeset

  schema "webhooks" do
    field :message, :string
    field :sender, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(webhook, attrs) do
    webhook
    |> cast(attrs, [:message, :sender])
    |> validate_required([:message, :sender])
  end
end
