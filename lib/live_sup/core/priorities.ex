defmodule LiveSup.Core.Priorities do
  alias LiveSup.Schemas.TodoTaskPriority

  def all do
    TodoTaskPriority.priorities_values()
    |> Enum.map(fn priority ->
      %TodoTaskPriority{
        id: priority,
        name: String.capitalize(priority),
        color: color(priority)
      }
    end)
  end

  # TODO: This is not correct, we should probably use just colors, and not classes
  # categories will grow over time, so this is gonna be dynamic.
  defp color("high"), do: "border-error/30 bg-error/10 uppercase text-error"
  defp color("medium"), do: "border-warning/30 bg-warning/10 uppercase text-warning"
  defp color("low"), do: "border-success/30 bg-success/10 uppercase text-success"
end
