defmodule LiveSup.Policies.ProjectPolicy do
  alias LiveSup.Core.Projects

  @behaviour Bodyguard.Policy

  def authorize(:read, _, %{internal: true}), do: :ok

  def authorize(:read, %{id: user_id}, project) do
    Projects.user_belongs_to?(user_id, project)
  end

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false
end
