defmodule LiveSupWeb.Api.LinkScanJSON do
  alias LiveSup.Schemas.Link

  def index(%{links: links}) do
    %{data: for(link <- links, do: data(link))}
  end

  def data({:error, :not_found}) do
    %{
      state: :user_not_found
    }
  end

  def data(%Link{} = link) do
    %{
      state: :created,
      id: link.id,
      settings: link.settings,
      user_id: link.user_id,
      datasource_instance_id: link.datasource_instance_id
    }
  end
end
