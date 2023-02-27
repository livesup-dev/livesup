defmodule LiveSup.Queries.TodoDatasourceQuery do
  import Ecto.Query

  alias LiveSup.Schemas.TodoDatasource
  alias LiveSup.Repo

  def all do
    base()
    |> Repo.all()
  end

  def update(%TodoDatasource{} = model, attrs) do
    model
    |> TodoDatasource.changeset(attrs)
    |> Repo.update()
  end

  def update!(%TodoDatasource{} = model, attrs) do
    model
    |> TodoDatasource.changeset(attrs)
    |> Repo.update!()
  end

  def get!(id) do
    base()
    |> Repo.get!(id)
  end

  def base,
    do:
      from(TodoDatasource,
        as: :todo_datasource,
        preload: [:todo, datasource_instance: [:datasource]]
      )
end
