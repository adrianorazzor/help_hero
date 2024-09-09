defmodule HelpHero.ContactsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HelpHero.Contacts` context.
  """

  @doc """
  Generate a contact.
  """
  def contact_fixture(attrs \\ %{}) do
    {:ok, contact} =
      attrs
      |> Enum.into(%{
        name: "some name",
        phone_number: "some phone_number"
      })
      |> HelpHero.Contacts.create_contact()

    contact
  end
end
