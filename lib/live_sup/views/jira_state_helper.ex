defmodule LiveSup.Views.JiraStateHelper do
  def status_icon("Open"), do: "fa-regular fa-circle text-stone-500"
  def status_icon("In Progress"), do: "fa-solid fa-circle-half-stroke text-orange-500"
  def status_icon("Complete"), do: "fa-solid fa-circle-check text-green-500"
  def status_icon("In Review"), do: "fa-solid fa-magnifying-glass text-blue-500"
  def status_icon("Blocked"), do: "fa-regular fa-circle-stop text-red-500"
  def status_icon(_), do: ""
end
