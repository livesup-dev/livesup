defmodule LiveSup.Schemas.TodoTaskPriority do
  defstruct [:id, :name, :color]

  @priorities_values [
    "high",
    "medium",
    "low"
  ]

  def priorities_values do
    @priorities_values
  end

  def high_priority, do: "high"
  def medium_priority, do: "medium"
  def low_priority, do: "low"
end
