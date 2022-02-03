defmodule LiveSup.Policies.DashboardPolicy do
  alias LiveSup.Core.Projects

  @behaviour Bodyguard.Policy

  # def authorize(:read, _, _), do: false

  def authorize(:read, %{id: user_id}, dashboard) do
    Projects.user_belongs_to?(user_id, dashboard)
  end

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false
end
