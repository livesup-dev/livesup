defmodule LiveSup.Policies.DatasourcePolicy do
  @behaviour Bodyguard.Policy

  def authorize(:read, _, _), do: :ok

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false
end
