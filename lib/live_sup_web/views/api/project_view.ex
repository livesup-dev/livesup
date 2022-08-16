defmodule LiveSupWeb.Api.ProjectView do
  use LiveSupWeb, :view
  alias LiveSupWeb.Api.ProjectView

  def render("index.json", %{projects: projects}) do
    %{data: render_many(projects, ProjectView, "project.json")}
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, ProjectView, "project.json")}
  end

  def render("project.json", %{project: project}) do
    %{
      id: project.id,
      name: project.name,
      avatar_url: project.avatar_url,
      internal: project.internal,
      inserted_at: project.inserted_at,
      updated_at: project.updated_at
    }
  end
end
