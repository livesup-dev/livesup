defmodule LiveSup.Seeds.Core.InternalDataSeeds do
  alias LiveSup.Repo
  alias LiveSup.Schemas.{ProjectGroup, Project}
  alias LiveSup.Queries.{ProjectQuery, GroupQuery}

  def seed, do: insert_data()

  defp insert_data do
    create_default_project()

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

  defp create_default_project() do
    LiveSup.Queries.ProjectQuery.get_internal_default_project() ||
      Project.changeset(%Project{}, %{
        name: "My Stuff",
        # TODO: We need to find a better name
        slug: "my-stuff",
        internal: true,
        default: true
      })
      |> Repo.insert!(on_conflict: :nothing)
  end
end
