defmodule LiveSupWeb.Live.Todo.Components.TaskDetails.TaskComponent do
  use LiveSupWeb, :component

  alias LiveSupWeb.Live.Todo.Components.TaskDetails.{
    LocalTaskComponent,
    GithubPullRequestTaskComponent
  }

  attr(:task, :map, required: true)
  attr(:editing_task, :boolean, default: false)
  attr(:error, :string, default: nil)

  def render(%{task: %{datasource_slug: nil}} = assigns) do
    assigns
    |> LocalTaskComponent.render()
  end

  def render(%{task: %{datasource_slug: "github-datasource"}} = assigns) do
    assigns
    |> GithubPullRequestTaskComponent.render()
  end
end
