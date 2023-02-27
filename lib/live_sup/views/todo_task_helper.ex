defmodule LiveSup.Views.TodoTaskHelper do
  def priority_class("high"), do: "badge space-x-2.5 px-1 text-error"
  def priority_class("medium"), do: "badge space-x-2.5 px-1 text-warning"
  def priority_class("low"), do: "badge space-x-2.5 px-1 text-info"
  def priority_class(nil), do: ""
end
