defmodule LiveSup.Seeds.InternalDataSeeds do
  use Mix.Task

  alias LiveSup.Repo
  alias LiveSup.Schemas.ProjectGroup
  alias LiveSup.Queries.{ProjectQuery, GroupQuery}

  def run(_) do
    Mix.Task.run("app.start", [])

    Mix.env()
    |> seed()
  end

  def seed(:dev) do
    insert_data()
  end

  def seed(:prod) do
    insert_data()
  end

  defp insert_data do
    public_project = ProjectQuery.get_internal_default_project()
    administrators_group = GroupQuery.get_administrator_group()
    all_users_group = GroupQuery.get_all_users_group()

    ProjectGroup.changeset(%ProjectGroup{}, %{
      project_id: public_project.id,
      group_id: administrators_group.id
    })
    |> Repo.insert!(on_conflict: :nothing)

    ProjectGroup.changeset(%ProjectGroup{}, %{
      project_id: public_project.id,
      group_id: all_users_group.id
    })
    |> Repo.insert!(on_conflict: :nothing)
  end
end
