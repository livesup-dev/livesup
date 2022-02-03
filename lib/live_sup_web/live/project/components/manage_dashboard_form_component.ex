defmodule LiveSupWeb.Project.Components.ManageDashboardFormComponent do
  use LiveSupWeb, :live_component
  alias LiveSup.Core.Dashboards
  alias LiveSup.Schemas.Dashboard

  @impl true
  def update(%{project: %{id: project_id}} = assigns, socket) do
    changeset = Dashboards.change(%Dashboard{project_id: project_id})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"dashboard" => dashboard_params}, socket) do
    changeset =
      socket.assigns.dashboard
      |> Dashboards.change(dashboard_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"dashboard" => dashboard_params}, socket) do
    save_dashboard(socket, socket.assigns.action, dashboard_params)
  end

  defp save_dashboard(socket, :new, dashboard_params) do
    case Dashboards.create(dashboard_params) do
      {:ok, _dashboard} ->
        {:noreply,
         socket
         |> put_flash(:info, "Dashboard creted successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
