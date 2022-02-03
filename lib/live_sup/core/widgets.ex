defmodule LiveSup.Core.Widgets do
  @moduledoc """
  The Widget context.
  """

  alias LiveSup.Schemas.{Widget, DatasourceInstance, WidgetInstance}
  alias LiveSup.Queries.{WidgetQuery, WidgetInstanceQuery}

  @doc """
  Returns the list of Widget.

  ## Examples

      iex> all()
      [%Widget{}, ...]

  """
  def all do
    WidgetQuery.all()
  end

  def all(%{datasource_id: _datasource_id} = filter) do
    filter |> WidgetQuery.all()
  end

  @doc """
  Gets a single widget.

  Raises `Ecto.NoResultsError` if the widget does not exist.

  ## Examples

      iex> get!(123)
      %Widget{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: WidgetQuery.get!(id)
  def get_instance!(id), do: WidgetInstanceQuery.get!(id)

  @doc """
  Creates a widget.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Widget{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    attrs
    |> WidgetQuery.create()
  end

  def create!(attrs \\ %{}) do
    attrs
    |> WidgetQuery.create!()
  end

  @doc """
  Updates a widget.

  ## Examples

      iex> update(widget, %{field: new_value})
      {:ok, %Widget{}}

      iex> update(widget, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Widget{} = widget, attrs) do
    widget
    |> WidgetQuery.update(attrs)
  end

  def get_by_slug!(slug), do: WidgetQuery.get_by_slug!(slug)
  def get_by_slug(slug), do: WidgetQuery.get_by_slug(slug)

  @doc """
  Deletes a widget.

  ## Examples

      iex> delete(widget)
      {:ok, %Widget{}}

      iex> delete(widget)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Widget{} = widget) do
    widget
    |> WidgetQuery.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking widget changes.

  ## Examples

      iex> change(Widget)
      %Ecto.Changeset{data: %Widget{}}

  """
  def change(%Widget{} = widget, attrs \\ %{}) do
    Widget.changeset(widget, attrs)
  end

  def delete_instance(%WidgetInstance{} = resource) do
    resource
    |> WidgetInstanceQuery.delete()
  end

  def create_instance(
        %Widget{} = widget,
        %DatasourceInstance{} = datasource_instance,
        settings \\ %{}
      ) do
    %{
      name: widget.name,
      enabled: widget.enabled,
      settings: Map.merge(widget.settings, settings),
      widget_id: widget.id,
      datasource_instance_id: datasource_instance.id
    }
    |> WidgetInstanceQuery.create()
  end

  def create_instance(attrs) do
    attrs
    |> WidgetInstanceQuery.create()
  end

  def update_instance(%WidgetInstance{} = widget_instance, attrs) do
    widget_instance
    |> WidgetInstanceQuery.update(attrs)
  end

  def change_instance(%WidgetInstance{} = model, attrs \\ %{}) do
    WidgetInstance.changeset(model, attrs)
  end
end
