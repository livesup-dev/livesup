defmodule LiveSup.Test.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveSup.Core.Projects` context.
  """

  alias LiveSup.Core.Todos
  alias LiveSup.Schemas.Project

  def todo_fixture(%Project{} = project, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(default_attrs())

    {:ok, todo} =
      project
      |> Todos.create(attrs)

    todo
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
