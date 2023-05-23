defmodule LiveSup.Views.TodoTaskHelper do
  def priority_class("high"), do: "badge space-x-2.5 px-1 text-error"
  def priority_class("medium"), do: "badge space-x-2.5 px-1 text-warning"
  def priority_class("low"), do: "badge space-x-2.5 px-1 text-info"
  def priority_class(nil), do: ""

  def task_icon(jira) when jira in ["github-datasource", "github", "Github"],
    do: "fa-brands fa-github text-black"

  def task_icon(jira) when jira in ["jira-datasource", "jira", "Jira"],
    do: "fa-brands fa-jira text-blue-600"
end
