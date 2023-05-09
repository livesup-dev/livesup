defmodule LiveSup.DataImporter.Cleaner do
  alias LiveSup.Core.{Projects, Dashboards, Teams, Todos}
  alias LiveSup.Queries.{MetricQuery, MetricValueQuery, WidgetInstanceQuery, NoteQuery}

  def clean(data) do
    data
    |> clean_projects()
    |> clean_teams()
    |> clean_metrics()
    |> clean_widgets_instances()
    |> clean_notes()
  end

  def clean_projects(%{"remove_existing_projects" => true} = data) do
    Projects.all()
    |> Enum.each(fn project ->
      project
      |> Dashboards.delete_all()

      project
      |> Todos.delete_all()

      {:ok, _proj} =
        project
        |> Projects.delete()
    end)

    data
  end

  def clean_projects(data), do: data

  def clean_teams(%{"remove_existing_teams" => true} = data) do
    Teams.all()
    |> Enum.each(fn team ->
      team
      |> Teams.delete_members()

      team
      |> Teams.delete()
    end)

    data
  end

  def clean_teams(data), do: data

  def clean_metrics(%{"remove_existing_metrics" => true} = data) do
    MetricValueQuery.delete_all()
    MetricQuery.delete_all()

    data
  end

  def clean_metrics(data), do: data

  def clean_widgets_instances(%{"remove_existing_widgets_instances" => true} = data) do
    WidgetInstanceQuery.delete_all()

    data
  end

  def clean_widgets_instances(data), do: data

  def clean_notes(%{"remove_existing_notes" => true} = data) do
    NoteQuery.delete_all()

    data
  end

  def clean_notes(data), do: data
end
