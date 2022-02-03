defmodule LiveSupWeb.ProjectController do
  use LiveSupWeb, :controller
  alias LiveSup.Core.Projects
  alias LiveSup.Policies.ProjectPolicy

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    projects = current_user |> Projects.by_user()

    render(conn, "index.html",
      current_user: current_user,
      projects: projects
    )
  end

  def show(conn, %{"id" => project_id}) do
    current_user = conn.assigns.current_user

    with {:ok, project} <- project_id |> Projects.get_with_dashboards(),
         :ok <- Bodyguard.permit(ProjectPolicy, :read, current_user, project) do
      render(conn, "show.html",
        current_user: current_user,
        project: project
      )
    end
  end
end
