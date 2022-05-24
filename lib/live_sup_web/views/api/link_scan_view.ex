defmodule LiveSupWeb.Api.LinkScanView do
  use LiveSupWeb, :view
  alias LiveSupWeb.Api.LinkScanView

  def render("index.json", %{links: links}) do
    %{data: render_many(links, LinkScanView, "link.json")}
  end

  def render("link.json", %{link_scan: link}) do
    %{
      id: link.id,
      settings: link.settings,
      user_id: link.user_id,
      datasource_instance_id: link.datasource_instance_id
    }
  end
end
