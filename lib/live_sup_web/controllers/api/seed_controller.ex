defmodule LiveSupWeb.Api.SeedController do
  use LiveSupWeb, :controller
  alias LiveSup.DataImporter.Importer

  def create(conn, %{"data" => data} = params) do
    async = Map.get(params, "async", false)

    state =
      case async do
        true ->
          perform(data)
          :running

        false ->
          Importer.perform(data)
          :ok
      end

    conn
    |> put_status(:created)
    |> render(:show, %{result: state})
  end

  def perform(data) do
    %{data: data}
    |> LiveSup.Workers.SeedWorker.new()
    |> Oban.insert()
  end
end
