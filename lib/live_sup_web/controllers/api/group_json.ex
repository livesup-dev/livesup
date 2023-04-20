defmodule LiveSupWeb.Api.GroupJSON do
  alias LiveSup.Schemas.Group

  def index(%{groups: groups}) do
    %{data: for(group <- groups, do: data(group))}
  end

  def show(%{group: group}) do
    %{data: data(group)}
  end

  def data(%Group{} = group) do
    %{
      id: group.id,
      internal: group.internal,
      name: group.name,
      slug: group.slug,
      inserted_at: group.inserted_at,
      updated_at: group.updated_at
    }
  end
end
