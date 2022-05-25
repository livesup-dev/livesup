defmodule LiveSupWeb.Api.LinkView do
  use LiveSupWeb, :view
  alias LiveSupWeb.Api.LinkView

  def render("index.json", %{links: links}) do
    %{data: render_many(links, LinkView, "link.json")}
  end

  def render("show.json", %{link: link}) do
    %{data: render_one(link, LinkView, "link.json")}
  end

  def render("link.json", %{link: link}) do
    %{
      id: link.id,
      settings: link.settings,
      user_id: link.user_id,
      datasource_instance_id: link.datasource_instance_id
    }
  end
end
