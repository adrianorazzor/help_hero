defmodule HelpHero.CompaniesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HelpHero.Companies` context.
  """

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> HelpHero.Companies.create_company()

    company
  end
end
