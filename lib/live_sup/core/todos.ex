defmodule LiveSup.Core.Todos do
  @moduledoc """
  The Todos context.
  """

  alias LiveSup.Schemas.{Todo, Project}
  alias LiveSup.Queries.{TodoQuery}
  alias LiveSup.Helpers.StringHelper

  @doc """
  Returns the list of todos.

  ## Examples

      iex> all()
      [%Todo{}, ...]

  """
  defdelegate by_project(project_id), to: TodoQuery

  def get(id) do
    id
    |> TodoQuery.get()
    |> found()
  end

  def get_with_project(id) do
    id
    |> TodoQuery.get_with_project()
    |> found()
  end

  defp found(nil), do: {:error, :not_found}
  defp found(resource), do: {:ok, resource}

  defdelegate get!(id), to: TodoQuery

  @doc """
  Creates a project.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Todo{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs) when is_map(attrs) do
    attrs
    |> TodoQuery.create()
  end

  def create(%Project{id: project_id}, attrs \\ %{}) do
    attrs
    |> StringHelper.keys_to_strings()
    |> Enum.into(%{"project_id" => project_id})
    |> TodoQuery.create()
  end

  @doc """
  Updates a dashboard.

  ## Examples

      iex> update(dashboard, %{field: new_value})
      {:ok, %Todo{}}

      iex> update(dashboard, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Todo{} = dashboard, attrs) do
    dashboard
    |> TodoQuery.update(attrs)
  end

  @doc """
  Deletes a dashboard.

  ## Examples

      iex> delete(dashboard)
      {:ok, %Todo{}}

      iex> delete(dashboard)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Todo{} = dashboard) do
    dashboard
    |> TodoQuery.delete()
  end

  def delete_all(%Project{} = project) do
    project
    |> TodoQuery.delete_all()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking dashboard changes.

  ## Examples

      iex> change(dashboard)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change(%Todo{} = dashboard, attrs \\ %{}) do
    Todo.changeset(dashboard, attrs)
  end
end
