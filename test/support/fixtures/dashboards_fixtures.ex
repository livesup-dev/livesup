defmodule LiveSup.Test.DashboardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveSup.Core.Projects` context.
  """

  alias LiveSup.Core.Dashboards
  alias LiveSup.Schemas.Project

  def dashboard_fixture(%Project{} = project, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(default_attrs())

    project
    |> Dashboards.create(attrs)
    |> elem(1)
  end

  defp default_attrs do
    %{
      name: "Cool Dashboard",
      default: true
    }
  end
end
