defmodule LiveSup.DataImporter.Cleaner do
  alias LiveSup.Core.{Projects, Dashboards}

  def clean(%{"remove_existing_projects" => true} = data) do
    Projects.all()
    |> Enum.each(fn project ->
      project
      |> Dashboards.delete_all()

      {:ok, _proj} =
        project
        |> Projects.delete()
    end)

    data
  end

  def clean(_), do: true
end
