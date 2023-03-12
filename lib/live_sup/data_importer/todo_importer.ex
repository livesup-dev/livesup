defmodule LiveSup.DataImporter.TodoImporter do
  alias LiveSup.Core.{Todos, Datasources}

  def import(%{"todos" => todos} = data) do
    todos
    |> Enum.each(fn attrs ->
      attrs
      |> get_or_create()
      |> add_datasources()
    end)

    data
  end

  def import(data), do: data

  defp get_or_create(%{"id" => id} = attrs) do
    {:ok, todo} =
      case Todos.get(id) do
        {:ok, todo} -> {:ok, todo}
        {:error, :not_found} -> {:ok, Todos.create!(attrs)}
      end

    # build the context
    %{todo: todo, attrs: attrs}
  end

  defp add_datasources(%{todo: todo, attrs: %{"datasources" => datasources}}) do
    datasources
    |> Enum.each(fn attrs ->
      datasource = Datasources.get_by_slug!(attrs["slug"])
      {:ok, datasource_instance} = Datasources.find_or_create_instance(datasource)

      Todos.upsert_datasource!(todo, %{
        datasource_instance_id: datasource_instance.id,
        settings: attrs["settings"] || %{}
      })
    end)
  end
end
