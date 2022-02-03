defmodule LiveSupWeb.Project.Components.DatasourceFormComponent do
  use LiveSupWeb, :live_component
  alias LiveSup.Core.Datasources

  @impl true
  def update(%{datasource: datasource} = assigns, socket) do
    changeset = Datasources.change_instance(datasource)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"datasource_instance" => datasource_params}, socket) do
    changeset =
      socket.assigns.datasource
      |> Datasources.change_instance(datasource_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"datasource_instance" => datasource_params}, socket) do
    save_datasource_instance(socket, socket.assigns.action, datasource_params)
  end

  def current_state(true), do: "Enabled"
  def current_state(false), do: "Disabled"

  defp save_datasource_instance(socket, :edit, datasource_params) do
    case Datasources.update_instance(socket.assigns.datasource, datasource_params) do
      {:ok, _datasource_instance} ->
        {:noreply,
         socket
         |> put_flash(:info, "Datasource updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
