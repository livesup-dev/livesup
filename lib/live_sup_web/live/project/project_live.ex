defmodule LiveSupWeb.Project.ProjectLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.Projects
  alias LiveSup.Schemas.{Project, User}
  alias Palette.Components.Breadcrumb.Step
  alias LiveSupWeb.ProjectLive.LiveComponents.ProjectFormComponent
  alias LiveSupWeb.Project.Components.ProjectStatComponent

  on_mount(LiveSupWeb.UserLiveAuth)

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_defaults()
     |> assign_breadcrumb_steps()
     |> assign_projects()
     |> assign(:project, nil)}
  end

  defp assign_breadcrumb_steps(socket) do
    steps = [
      %Step{label: "Home"}
    ]

    socket
    |> assign(:steps, steps)
  end

  defp assign_defaults(socket) do
    socket
    |> assign(title: "Projects")
    |> assign_page_title("Projects")
    |> assign(section: :home)
  end

  defp assign_page_title(socket, title) do
    socket
    |> assign(:page_title, title)
  end

  defp assign_projects(%{assigns: %{current_user: current_user}} = socket) do
    projects = current_user |> Projects.by_user()

    socket
    |> stream(:projects, projects)
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign_page_title("New project")
    |> assign(:project, %Project{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign_page_title("Projects")
    |> assign(:project, nil)
  end

  defp users_from_groups(groups) do
    groups
    |> Enum.map(fn group -> group.users end)
    |> List.flatten()
    |> Enum.uniq()
  end

  defp project_color(%Project{color: nil}), do: ""
  defp project_color(%Project{color: color}), do: "background-color:##{color}"
end
