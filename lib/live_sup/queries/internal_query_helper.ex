defmodule LiveSup.Queries.InternalQueryHelper do
  import Ecto.Query

  def with_internal_resource(query, slug) do
    query
    |> with_slug(slug)
    |> is_internal()
  end

  def with_slug(query, slug) do
    query
    |> where(slug: ^slug)
  end

  def is_internal(query) do
    query
    |> where(internal: true)
  end
end
