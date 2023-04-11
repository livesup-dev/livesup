defmodule LiveSupWeb.Project.DashboardLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.{Projects, Dashboards, Widgets.WidgetManager}
  alias LiveSup.Core.Utils
  alias LiveSup.Schemas.{Project, Dashboard, User}
  alias Palette.Components.Breadcrumb.Step
  alias LiveSupWeb.ProjectLive.LiveComponents.DashboardFormComponent

  on_mount(LiveSupWeb.UserLiveAuth)

  @impl true
  def mount(_params, session, socket) do
    current_user = get_current_user(session, socket)

    {:ok,
     socket
     |> assign(:draggable_class, "")
     |> assign(:current_user, current_user)
     |> assign(:dashboard, nil)
     |> assign_defaults()}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => dashboard_id}) do
    socket
    |> assign(:draggable_class, "draggable")
    |> manage_widgets(dashboard_id)
  end

  defp apply_action(socket, :show, %{"id" => dashboard_id}) do
    socket
    |> assign(:draggable_class, "")
    |> manage_widgets(dashboard_id)
  end

  defp apply_action(socket, :index, %{"id" => project_id}) do
    project = Projects.get!(project_id)

    socket
    |> assign_title(project)
    |> assign_project(project)
    |> assign_dashboards(project)
    |> assign_breadcrumb_project_steps(project)
    |> assign_section()
    |> redirect_if_one_dashboard()
  end

  defp apply_action(socket, :new, %{"id" => project_id}) do
    project = Projects.get!(project_id)

    socket
    |> assign(page_title: "New dashboard")
    |> assign_project(project)
    |> assign(:dashboard, %Dashboard{})
  end

  defp manage_widgets(socket, dashboard_id) do
    {:ok, dashboard} = dashboard_id |> Dashboards.get_with_project()

    widget_instances =
      get_and_start_widgets(
        dashboard.id,
        socket.assigns[:current_user]
      )

    socket
    |> assign(:widget_instances, widget_instances)
    |> assign(:current_dashboard, dashboard)
    |> assign(:dashboard, dashboard)
    |> assign_dashboards(dashboard.project)
    |> assign(:project, dashboard.project)
    |> assign(:section, :dashboard)
    |> assign(:title, "Dashboard")
    |> assign_breadcrumb_dashboard_steps(dashboard)
  end

  def redirect_if_one_dashboard(socket) when length(socket.assigns.dashboards) == 1 do
    %{id: dashboard_id} =
      socket.assigns.dashboards
      |> Enum.at(0)

    redirect(socket, to: ~p"/dashboards/#{dashboard_id}")
  end

  def redirect_if_one_dashboard(socket) when length(socket.assigns.dashboards) != 1, do: socket

  @impl true
  def handle_event(
        "dropped",
        %{"widget_id" => widget_id, "old_index" => _old_index, "new_index" => new_index},
        %{assigns: %{current_dashboard: %{id: dashboard_id}}} = socket
      ) do
    {:ok, _updated} = Dashboards.update_widget_instance_order(dashboard_id, widget_id, new_index)

    {:noreply, socket}
  end

  defp assign_defaults(socket) do
    steps = [
      %Step{label: "Home"}
    ]

    socket
    |> assign(title: "Dashboards")
    |> assign(:page_title, "Projects")
    |> assign(section: :dashboard)
    |> assign(:steps, steps)
  end

  defp assign_title(socket, %{name: name}) do
    socket
    |> assign(title: "Dashboards")
  end

  defp assign_project(socket, project) do
    socket
    |> assign(project: project)
  end

  defp assign_breadcrumb_dashboard_steps(socket, dashboard) do
    steps = [
      %Step{label: "Projects", path: ~p"/projects"},
      %Step{
        label: dashboard.project.name,
        path: ~p"/projects"
      },
      %Step{
        label: "Dashboards",
        path: ~p"/projects/#{dashboard.project.id}/dashboards"
      },
      %Step{label: dashboard.name}
    ]

    socket
    |> assign(:steps, steps)
  end

  defp assign_breadcrumb_project_steps(socket, project) do
    steps = [
      %Step{label: "Projects", path: ~p"/projects"},
      %Step{
        label: project.name,
        path: ~p"/projects"
      },
      %Step{
        label: "Dashboards"
      }
    ]

    socket
    |> assign(:steps, steps)
  end

  defp assign_dashboards(socket, %{id: project_id}) do
    dashboards = Dashboards.by_project(project_id)

    socket
    |> assign(dashboards: dashboards)
  end

  defp assign_section(socket) do
    socket
    |> assign(section: :dashboard_selection)
  end

  def size(widget_instance) do
    widget_instance.widget.ui_settings["size"] || 1
  end

  def get_and_start_widgets(dashboard_id, current_user) do
    widget_instances =
      dashboard_id
      |> Dashboards.widgets_instances()

    # TODO: We can't use spawn here, since the UI will try to
    # have access to the workers without them being initialized
    # but we need to be careful with performance and the time it
    # takes to render the view
    widget_instances
    |> WidgetManager.start_widgets(current_user)

    widget_instances
  end
end
