defmodule LiveSupWeb.Api.MetricJSON do
  alias LiveSup.Schemas.Metric

  def index(%{metrics: metrics}) do
    %{data: for(metric <- metrics, do: data(metric))}
  end

  def show(%{metric: metric}) do
    %{data: data(metric)}
  end

  def data(%Metric{} = metric) do
    %{
      id: metric.id,
      name: metric.name,
      slug: metric.slug,
      target: metric.target,
      unit: metric.unit,
      settings: metric.settings,
      inserted_at: metric.inserted_at,
      updated_at: metric.updated_at
    }
  end
end
