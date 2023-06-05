defmodule LiveSupWeb.Api.LinkJSON do
  alias LiveSup.Schemas.Link

  def index(%{links: links}) do
    %{data: for(link <- links, do: data(link))}
  end

  def show(%{link: link}) do
    %{data: data(link)}
  end

  def data(%Link{} = link) do
    %{
      id: link.id,
      settings: link.settings,
      user_id: link.user_id,
      datasource_instance_id: link.datasource_instance_id,
      datasource_slug: link.datasource_slug,
      inserted_at: link.inserted_at,
      updated_at: link.updated_at
    }
  end
end
