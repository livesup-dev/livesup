defmodule LiveSup.Test.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveSup.Core.Projects` context.
  """

  alias LiveSup.Core.Projects

  def internal_default_project_fixture() do
    Projects.create_internal_default_project()
    |> elem(1)
  end

  def project_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(ramdom_attrs())
    |> Projects.create()
    |> elem(1)
  end

  defp ramdom_attrs() do
    id = System.unique_integer()

    %{
      name: "Random-#{id}",
      slug: "random-#{id}",
      internal: false,
      color: Palette.Utils.ColorHelper.hex()
    }
  end
end
