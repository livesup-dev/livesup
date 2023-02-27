defmodule LiveSupWeb.Project.DatasourceLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.{Projects, Datasources}

  on_mount(LiveSupWeb.UserLiveAuth)

  @impl true
  def mount(%{"project_id" => project_id}, _session, socket) do
    project = Projects.get!(project_id)

    {:ok,
     socket
     |> assign_title(project)
     |> assign_project(project)
     |> assign_datasources(project)
     |> assign_section()}
  end

  @impl true
  def mount(%{"project_id" => project_id, "id" => datasource_instance_id}, _session, socket) do
    # This mount is used if you are trying to access the page
    # directly, like using /projects/:project_id/datasources/:id/edit
    project = Projects.get!(project_id)

    {:ok,
     socket
     |> assign_datasources(project)
     |> assign_datasource(datasource_instance_id)
     |> assign_section()}
  end

  defp assign_datasource(socket, datasource_instance_id) do
    socket
    |> assign(:datasource, Datasources.get_instance!(datasource_instance_id))
  end

  defp assign_title(socket, %{name: name}) do
    socket
    |> assign(title: "#{name} > Datasources")
  end

  defp assign_project(socket, project) do
    socket
    |> assign(project: project)
  end

  defp assign_datasources(socket, project) do
    socket
    |> assign(datasources: datasources(project))
  end

  defp assign_section(socket) do
    socket
    |> assign(section: :project_settings)
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => datasource_instance_id}) do
    socket
    |> assign(:page_title, "Edit datasource")
    |> assign(:datasource, Datasources.get_instance!(datasource_instance_id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing datasources")
    |> assign(:datasource, nil)
  end

  defp datasources(project) do
    Datasources.instances_by_project(project)
  end
end
