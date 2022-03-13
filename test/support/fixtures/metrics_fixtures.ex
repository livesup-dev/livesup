defmodule LiveSup.Test.MetricsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveSup.Core.Projects` context.
  """

  alias LiveSup.Core.Metrics

  def metric_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(ramdom_attrs())
    |> Metrics.create!()
  end

  defp ramdom_attrs() do
    id = System.unique_integer()

    %{
      name: "Random-#{id}",
      target: 8,
      unit: "%"
    }
  end
end
