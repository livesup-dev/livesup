defmodule LiveSup.Workers.SeedWorker do
  alias LiveSup.DataImporter.Importer

  use Oban.Worker,
    queue: :seed,
    max_attempts: 1

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"data" => data}}) do
    Importer.perform(data)

    :ok
  end
end
