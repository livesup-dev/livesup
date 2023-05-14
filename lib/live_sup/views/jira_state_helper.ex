defmodule LiveSup.Views.JiraStateHelper do
  def status_icon("Open"), do: "fa-regular fa-circle text-stone-500"
  def status_icon("In Progress"), do: "fa-solid fa-circle-half-stroke text-orange-400"
  def status_icon("Completed"), do: "fa-solid fa-circle-check text-green-500"
  def status_icon(_), do: ""
end
