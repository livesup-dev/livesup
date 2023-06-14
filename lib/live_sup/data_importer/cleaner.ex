defmodule LiveSup.DataImporter.Cleaner do
  alias LiveSup.Core.{Projects, Dashboards, Teams, Todos, Comments, Tasks}

  alias LiveSup.Queries.{
    MetricQuery,
    MetricValueQuery,
    WidgetInstanceQuery,
    NoteQuery,
    UserQuery,
    LinkQuery,
    GroupQuery,
    CommentQuery,
    TaskQuery,
    TodoQuery
  }

  def clean(data) do
    data
    |> clean_tasks()
    |> clean_projects()
    |> clean_teams()
    |> clean_metrics()
    |> clean_widgets_instances()
    |> clean_notes()
    |> clean_groups()
    |> clean_users()
  end

  def clean_tasks(%{"remove_existing_tasks" => true} = data) do
    CommentQuery.delete_all()
    TaskQuery.delete_all()
    TodoQuery.delete_all()

    data
  end

  def clean_tasks(data), do: data

  def clean_projects(%{"remove_existing_projects" => true} = data) do
    Dashboards.delete_all()
    Comments.delete_all()
    Tasks.delete_all()
    Todos.delete_all()
    Projects.delete_all()

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

  def clean_groups(%{"remove_existing_groups" => true} = data) do
    GroupQuery.non_internal_groups()
    |> Enum.each(fn group ->
      group
      |> GroupQuery.delete()
    end)

    data
  end

  def clean_groups(data), do: data

  def clean_users(%{"remove_existing_users" => true} = data) do
    LinkQuery.delete_all()
    UserQuery.delete_all()

    data
  end

  def clean_users(data), do: data
end
