defmodule LiveSup.Test.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveSup.Core.Projects` context.
  """

  alias LiveSup.Queries.TodoDatasourceQuery
  alias LiveSup.Core.Todos
  alias LiveSup.Schemas.{Project, Todo, Datasource}

  def todo_fixture(%Project{} = project, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(default_attrs())

    {:ok, todo} =
      project
      |> Todos.create(attrs)

    todo
    |> Todos.get!()
  end

  def todo_datasource(%Todo{} = todo, %Datasource{} = datasource) do
    %{id: datasource_instance_id} =
      datasource
      |> LiveSup.Test.DatasourcesFixtures.datasource_instance_fixture()

    %{id: id} =
      Todos.upsert_datasource!(todo, %{
        datasource_instance_id: datasource_instance_id,
        settings: %{state: "open", limit: 10}
      })

    TodoDatasourceQuery.get!(id)
  end

  def todo_archived_fixture(%Project{} = project, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(default_attrs())
      |> Enum.into(%{archived: true})

    project
    |> Todos.create(attrs)
    |> elem(1)
    |> Todos.get!()
  end

  defp default_attrs do
    %{
      title: "Upgrade libs - #{System.unique_integer()}",
      description: "Some generic description - #{System.unique_integer()}",
      color_code: "#fff"
    }
  end
end
