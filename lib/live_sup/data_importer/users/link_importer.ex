defmodule LiveSup.DataImporter.Users.LinkImporter do
  alias LiveSup.Core.{Datasources, Links}
  alias LiveSup.Schemas.User

  def perform(%User{} = user, %{"links" => links}) do
    user |> perform(links)
  end

  def perform(%User{} = user, data) when is_binary(data) do
    data =
      data
      |> LiveSup.DataImporter.Importer.parse_yaml()

    user |> perform(data)
  end

  def perform(%User{id: user_id}, data) when is_list(data) do
    data
    |> Enum.each(fn %{"datasource_slug" => datasource_slug} = link_attrs ->
      {:ok, %{id: datasource_instance_id}} = Datasources.find_or_create_instance(datasource_slug)

      link_attrs
      |> Map.put("datasource_instance_id", datasource_instance_id)
      |> Map.put("user_id", user_id)
      |> Links.upsert()
    end)
  end
end
