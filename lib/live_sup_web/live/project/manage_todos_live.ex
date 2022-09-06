defmodule LiveSupWeb.Project.ManageTodosLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.Projects

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"id" => project_id}) do
    socket
    |> assign(:project, Projects.get_with_todos!(project_id))
  end

  defp apply_action(socket, :new, %{"id" => project_id}) do
    socket
    |> assign(:project, Projects.get_with_todos!(project_id))
  end
end