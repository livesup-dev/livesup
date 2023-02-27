defmodule LiveSup.Test.DatasourcesFixtures do
  alias LiveSup.Core.Datasources

  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveSup.Core.Datasources` context.
  """

  def datasource_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(default_attrs())
    |> find_or_create()
  end

  defp find_or_create(%{slug: slug} = attrs) do
    datasource = Datasources.get_by_slug(slug)

    case datasource do
      nil ->
        attrs
        |> Datasources.create()
        |> elem(1)

      datasource ->
        datasource
    end
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

  def add_github_datasource() do
    %{
      name: "Github",
      slug: "github-datasource",
      enabled: "true",
      settings: %{
        "token" => %{
          "source" => "local",
          "value" => "gb-token",
          "required" => true,
          "type" => "string"
        },
        "owner" => %{
          "type" => "string",
          "required" => true,
          "value" => "livesup-dev",
          "source" => "local"
        },
        "repository" => %{
          "type" => "string",
          "required" => true,
          "value" => "livesup",
          "source" => "local"
        }
      }
    }
    |> datasource_fixture()
  end

  def add_jira_datasource() do
    %{
      name: "Jira",
      slug: "jira-datasource",
      enabled: true,
      labels: [],
      settings: %{"token" => "1234", "domain" => "livesup.jira.com"}
    }
    |> datasource_fixture()
  end

  def add_jira_datasource_instance() do
    {:ok, instance} =
      add_jira_datasource()
      |> LiveSup.Core.Datasources.create_instance()

    instance
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

  def add_pager_duty_datasource_instance() do
    {:ok, instance} =
      add_pager_duty_datasource()
      |> LiveSup.Core.Datasources.create_instance()

    instance
  end
end
