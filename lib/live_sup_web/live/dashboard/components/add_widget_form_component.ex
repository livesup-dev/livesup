defmodule LiveSupWeb.Dashboard.Components.AddWidgetFormComponent do
  use LiveSupWeb, :live_component

  alias LiveSup.Core.{Widgets, Datasources, Dashboards}
  alias LiveSup.Schemas.{Widget, Dashboard, Project, Datasource}

  @impl true
  def update(%{widget_instance: widget_instance} = assigns, socket) do
    changeset = Widgets.change_instance(widget_instance)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_datasource_instances(assigns.datasource_id)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"widget_instance" => widget_instance_params}, socket) do
    changeset =
      socket.assigns.widget_instance
      |> Widgets.change_instance(widget_instance_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"widget_instance" => widget_instance_params}, socket) do
    save_widget_instance(socket, socket.assigns.action, widget_instance_params)
  end

  defp assign_datasource_instances(socket, datasource_id) do
    dashboard = socket.assigns.dashboard

    datasource_instances =
      Datasources.search(%Project{id: dashboard.project_id}, %Datasource{id: datasource_id})

    socket
    |> assign(:datasource_instances, datasource_instances)
  end

  defp save_widget_instance(
         socket,
         :add,
         %{"dashboard_id" => dashboard_id} = widget_instance_params
       ) do
    {:ok, widget_instance} = Widgets.create_instance(widget_instance_params)

    case Dashboards.add_widget(%Dashboard{id: dashboard_id}, widget_instance) do
      {:ok, _widget_instance} ->
        {:noreply,
         socket
         |> put_flash(:info, "Widget added successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
