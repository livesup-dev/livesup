defmodule LiveSup.Core.Metrics do
  use Task
  alias LiveSup.Queries.{MetricQuery}

  def by_slug(slug) do
    slug |> MetricQuery.by_slug()
  end
end
