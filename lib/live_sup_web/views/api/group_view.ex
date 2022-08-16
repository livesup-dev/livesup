defmodule LiveSupWeb.Api.GroupView do
  use LiveSupWeb, :view
  alias LiveSupWeb.Api.GroupView

  def render("index.json", %{groups: groups}) do
    %{data: render_many(groups, GroupView, "group.json")}
  end

  def render("show.json", %{group: group}) do
    %{data: render_one(group, GroupView, "group.json")}
  end

  def render("group.json", %{group: group}) do
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
