defmodule HelpHeroWeb.CompanyLive.FormComponent do
  use HelpHeroWeb, :live_component

  alias HelpHero.Companies

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage company records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="company-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Company</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{company: company} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Companies.change_company(company))
     end)}
  end

  @impl true
  def handle_event("validate", %{"company" => company_params}, socket) do
    changeset = Companies.change_company(socket.assigns.company, company_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"company" => company_params}, socket) do
    save_company(socket, socket.assigns.action, company_params)
  end

  defp save_company(socket, :edit, company_params) do
    case Companies.update_company(socket.assigns.company, company_params) do
      {:ok, company} ->
        notify_parent({:saved, company})

        {:noreply,
         socket
         |> put_flash(:info, "Company updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_company(socket, :new, company_params) do
    case Companies.create_company(company_params) do
      {:ok, company} ->
        notify_parent({:saved, company})

        {:noreply,
         socket
         |> put_flash(:info, "Company created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
