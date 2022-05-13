defmodule LiveSup.Test.DatasourcesFixtures do
  alias LiveSup.Core.Datasources

  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveSup.Core.Datasources` context.
  """

  def datasource_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(default_attrs())
    |> Datasources.create()
    |> elem(1)
  end

  def datasource_instance_fixture(datasource \\ datasource_fixture()) do
    datasource
    |> Datasources.create_instance(%{})
    |> elem(1)
  end

  defp default_attrs() do
    %{
      name: "Rollbar",
      slug: "rollbar#{System.unique_integer()}",
      enabled: true,
      labels: [],
      settings: %{"api_key" => nil}
    }
  end

  def add_jira_datasource() do
    %{
      name: "Jira",
      slug: "jira-datasource",
      enabled: true,
      labels: [],
      settings: %{"account_id" => nil}
    }
    |> datasource_fixture()
  end

  def add_pager_duty_datasource() do
    %{
      name: "PagerDuty",
      slug: "pager-duty",
      enabled: true,
      labels: [],
      settings: %{"api_key" => nil}
    }
    |> datasource_fixture()
  end
end
