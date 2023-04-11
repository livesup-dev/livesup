defmodule LiveSupWeb.ProjectLive.LiveComponents.DashboardFormComponent do
  use LiveSupWeb, :live_component

  alias LiveSup.Core.{Dashboards, Projects}
  alias LiveSup.Schemas.Dashboard

  @impl true
  def update(%{dashboard: dashboard, project: project} = assigns, socket) do
    changeset = Dashboards.change(%Dashboard{}, %{project_id: project.id})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:error, nil)
     |> assign(:dashboard, %Dashboard{})
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", dashboard_params, socket) do
    changeset =
      %Dashboard{}
      |> Dashboards.change(dashboard_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", dashboard_params, socket) do
    save(socket, socket.assigns.action, dashboard_params)
  end

  defp save(%{assigns: %{project: project}} = socket, :new, dashboard_params) do
    case Dashboards.create(project, dashboard_params) do
      {:ok, _dashboard} ->
        {:noreply,
         socket
         |> put_flash(:info, "Dashboard created successfully")
         |> push_redirect(to: ~p"/projects/#{project.id}/dashboards")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
