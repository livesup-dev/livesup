defmodule LiveSup.Release do
  @app :live_sup

  def migrate do
    # TODO: This is bad.. because it's loading the whole app, and I only need a few apps
    # to run the seeds, but I coudn't find the right combination.
    # {:ok, _} = Application.ensure_all_started(:live_sup)

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))

      {:ok, _, _} = Ecto.Migrator.with_repo(repo, fn _repo -> LiveSup.Seeds.seed() end)
    end

    #
  end

  def rollback(repo, version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end
end
