defmodule LiveSupWeb.Project.ManageTodosLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.Projects

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => project_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:project, Projects.get_with_todos!(project_id))}
  end
end
