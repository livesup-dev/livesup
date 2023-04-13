defmodule LiveSup.Queries.ProjectQuery do
  import LiveSup.Queries.InternalQueryHelper
  import Ecto.Query

  alias LiveSup.Schemas.{User, Project, UserGroup, ProjectGroup, Dashboard}
  alias LiveSup.Repo

  @internal_default_project_slug "my-stuff"

  def all do
    base()
    |> Repo.all()
  end

  def get!(id) do
    base()
    |> Repo.get!(id)
  end

  def get(id) do
    base()
    |> Repo.get(id)
  end

  def get_with_dashboards!(id) do
    get_with_dashboard_query()
    |> Repo.get!(id)
  end

  def get_with_dashboards(id) do
    get_with_dashboard_query()
    |> Repo.get(id)
  end

  def get_with_users(id) do
    base()
    |> preload(groups: :users)
    |> Repo.get(id)
  end

  def get_with_todos!(id) do
    get_with_todos_query()
    |> Repo.get!(id)
  end

  def get_with_todos(id) do
    get_with_todos_query()
    |> Repo.get(id)
  end

  defp get_with_dashboard_query() do
    base()
    |> with_dashboards()
  end

  defp get_with_todos_query() do
    base()
    |> with_todos()
  end

  def create(attrs) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  def create!(attrs) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert!()
  end

  def create_internal_default_project() do
    attrs = %{
      # TODO: We need to find a better name
      name: "My Stuff",
      slug: @internal_default_project_slug,
      internal: true,
      default: true,
      color: Palette.Utils.ColorHelper.hex()
    }

    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  def update(project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  def delete(project) do
    project
    |> Repo.delete()
  end

  def get_internal_default_project do
    base()
    |> with_internal_resource(@internal_default_project_slug)
    |> Repo.one()
  end

  def by_user(%User{id: user_id}) do
    internal_project_query =
      base()
      |> with_internal_resource(@internal_default_project_slug)

    base()
    |> with_groups(user_id)
    |> with_dashboards()
    |> union(^internal_project_query)
    |> order_by(fragment("name"))
    |> preload(groups: :users)
    |> Repo.all()
  end

  def user_belongs_to?(user_id, %Project{id: project_id}) do
    base()
    |> with_groups(user_id)
    |> where([project_group: pg], pg.project_id == ^project_id)
    |> Repo.exists?()
  end

  def user_belongs_to?(user_id, %Dashboard{id: dashboard_id}) do
    base()
    |> with_groups(user_id)
    |> join(:inner, [p], d in Dashboard,
      as: :dashboard,
      on: d.project_id == p.id
    )
    |> where([dashboard: d], d.id == ^dashboard_id)
    |> Repo.exists?()
  end

  def with_groups(query \\ base(), user_id) do
    query
    |> with_groups_query()
    |> where([project, user_group: ug], ug.user_id == ^user_id)
  end

  def with_dashboards(query \\ base()) do
    query
    |> preload(:dashboards)
  end

  def with_todos(query \\ base()) do
    query
    |> preload(:todos)
  end

  def with_groups_query(query \\ base()) do
    query
    |> join(:left, [project], pg in ProjectGroup,
      as: :project_group,
      on: pg.project_id == project.id
    )
    |> join(:left, [project, project_group: pg], ug in UserGroup,
      as: :user_group,
      on: ug.group_id == pg.group_id
    )
  end

  def base do
    from(project in Project,
      as: :project,
      select_merge: %{
        todos_count:
          fragment(
            "SELECT count(*) FROM todos WHERE project_id = ?",
            project.id
          ),
        dashboards_count:
          fragment(
            "SELECT count(*) FROM dashboards WHERE project_id = ?",
            project.id
          )
      }
    )
  end
end
