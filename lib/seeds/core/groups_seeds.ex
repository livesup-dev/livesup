defmodule LiveSup.Seeds.Core.GroupsSeeds do
  alias LiveSup.Repo
  alias LiveSup.Schemas.Group

  def seed, do: insert_data()

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
