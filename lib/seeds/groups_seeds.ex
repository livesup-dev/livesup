defmodule LiveSup.Seeds.GroupsSeeds do
  use Mix.Task

  alias LiveSup.Repo
  alias LiveSup.Schemas.Group

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
    [
      %{
        name: "Administrators",
        internal: true,
        slug: "administrators"
      },
      %{
        name: "All Users",
        internal: true,
        slug: "all-users"
      }
    ]
    |> Enum.map(fn data ->
      insert(data)
    end)
  end

  defp insert(data) do
    Group.changeset(%Group{}, data)
    |> Repo.insert!(on_conflict: :nothing)
  end
end
