defmodule HelpHero.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :name, :string
    field :phone_number, :string
    belongs_to :company, HelpHero.Companies.Company
    has_many :conversations, HelpHero.Conversations.Conversation

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :phone_number])
    |> validate_required([:name, :phone_number])
  end
end
