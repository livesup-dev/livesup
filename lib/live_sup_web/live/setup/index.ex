defmodule LiveSupWeb.SetupLive.Index do
  use LiveSupWeb, :live_view

  alias LiveSupWeb.SetupLive.Step
  alias LiveSup.Core.Projects
  import LiveSupWeb.Live.AuthHelper

  @first_step %Step{name: :project, prev: nil, next: :dashboard}

  @steps [
    @first_step,
    %Step{name: :dashboard, prev: :project, next: :datasources},
    %Step{name: :datasources, prev: :dashboard, next: :widgets},
    %Step{name: :widgets, prev: :datasources, next: nil}
  ]

  @impl true
  def mount(_params, session, socket) do
    current_user = get_current_user(session, socket)

    {:ok,
     socket
     |> assign_title()
     |> assign_step()
     |> assign_current_project(nil)
     |> assign_current_user(current_user)}
  end

  def assign_title(socket) do
    socket |> assign(:title, "Setup")
  end

  def assign_current_project(socket, project) do
    socket |> assign(:current_project, project)
  end

  def assign_step(socket) do
    socket |> assign(:current_step, @first_step)
  end

  def assign_current_user(socket, current_user) do
    socket |> assign(:current_user, current_user)
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:project_created, project}, socket) do
    {:noreply, socket |> assign_current_project(project)}
  end

  @impl true
  def handle_info({:project_selected, project_id}, socket) do
    project = Projects.get!(project_id)

    {:noreply, socket |> assign_current_project(project)}
  end
end
