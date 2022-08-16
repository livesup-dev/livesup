defmodule LiveSupWeb.Api.MetricView do
  use LiveSupWeb, :view
  alias LiveSupWeb.Api.MetricView

  def render("index.json", %{metrics: metrics}) do
    %{data: render_many(metrics, MetricView, "metric.json")}
  end

  def render("show.json", %{metric: metric}) do
    %{data: render_one(metric, MetricView, "metric.json")}
  end

  def render("metric.json", %{metric: metric}) do
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
