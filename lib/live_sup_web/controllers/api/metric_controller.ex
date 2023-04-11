defmodule LiveSupWeb.Api.MetricController do
  use LiveSupWeb, :api_controller

  alias LiveSup.Core.Metrics
  alias LiveSup.Schemas.Metric

  def index(conn, _params) do
    metrics = Metrics.all()
    render(conn, "index.json", metrics: metrics)
  end

  def create(conn, %{"metric" => metric_params}) do
    with {:ok, %Metric{} = metric} <- Metrics.create(metric_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", "/api/metrics/#{metric.id}")
      |> render("show.json", metric: metric)
    end
  end

  def show(conn, %{"id" => id}) do
    metric = Metrics.get!(id)
    render(conn, "show.json", metric: metric)
  end

  def update(conn, %{"id" => id, "metric" => metric_params}) do
    metric = Metrics.get!(id)

    with {:ok, %Metric{} = metric} <- Metrics.update(metric, metric_params) do
      render(conn, "show.json", metric: metric)
    end
  end

  def delete(conn, %{"id" => id}) do
    metric = Metrics.get!(id)

    with {:ok, %Metric{}} <- Metrics.delete(metric) do
      send_resp(conn, :no_content, "")
    end
  end
end
