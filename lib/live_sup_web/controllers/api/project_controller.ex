defmodule LiveSupWeb.Api.ProjectController do
  use LiveSupWeb, :api_controller

  alias LiveSup.Core.Projects
  alias LiveSup.Schemas.Project

  def index(conn, _params) do
    projects = Projects.all()
    render(conn, "index.json", projects: projects)
  end

  def create(conn, %{"project" => project_params}) do
    with {:ok, %Project{} = project} <- Projects.create(project_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", "/api/projects/#{project.id}")
      |> render("show.json", project: project)
    end
  end

  def show(conn, %{"id" => id}) do
    project = Projects.get!(id)
    render(conn, "show.json", project: project)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Projects.get!(id)

    with {:ok, %Project{} = project} <- Projects.update(project, project_params) do
      render(conn, "show.json", project: project)
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Projects.get!(id)

    with {:ok, %Project{}} <- Projects.delete(project) do
      send_resp(conn, :no_content, "")
    end
  end
end
