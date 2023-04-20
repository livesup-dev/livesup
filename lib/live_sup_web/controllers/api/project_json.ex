defmodule LiveSupWeb.Api.ProjectJSON do
  alias LiveSup.Schemas.Project

  def render(%{projects: projects}) do
    %{data: for(project <- projects, do: data(project))}
  end

  def show(%{project: project}) do
    %{data: data(project)}
  end

  def data(%Project{} = project) do
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
