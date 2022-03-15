defmodule LiveSupWeb.DatasourceController do
  use LiveSupWeb, :controller
  alias LiveSup.Core.{Datasources, Projects}
  alias LiveSup.Policies.ProjectPolicy

  def index(conn, %{"id" => project_id}) do
    current_user = conn.assigns.current_user
    project = Projects.get!(project_id)

    with :ok <- Bodyguard.permit(ProjectPolicy, :read, current_user, project),
         {:ok, datasources} <- Datasources.all() do
      render(conn, "index.html",
        section: :project_settings,
        current_user: current_user,
        datasources: datasources,
        project: project
      )
    end
  end
end
