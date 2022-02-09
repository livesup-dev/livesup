defmodule LiveSup.Seeds.DatasourcesSeeds do
  alias LiveSup.Repo
  alias LiveSup.Schemas.Datasource
  def seed, do: insert_data()

  defp insert_data do
    [
      %{
        name: "Local",
        slug: "local-datasource",
        enabled: "true",
        settings: %{}
      },
      %{
        name: "Chuck Norries",
        slug: "chuck-norries-datasource",
        enabled: "true",
        settings: %{}
      },
      %{
        name: "RSS",
        slug: "rss-datasource",
        enabled: "true",
        settings: %{
          "url" => %{
            "source" => "local",
            "value" => "",
            "type" => "string",
            "required" => true
          }
        }
      },
      %{
        name: "Jira",
        slug: "jira-datasource",
        enabled: "true",
        settings: %{
          "token" => %{
            "source" => "env",
            "value" => "JIRA_TOKEN",
            "type" => "string",
            "required" => true
          },
          "domain" => %{
            "source" => "env",
            "value" => "JIRA_DOMAIN",
            "type" => "string",
            "required" => true
          }
        }
      },
      %{
        name: "Lord of the Ring",
        slug: "lord-of-ring-datasource",
        enabled: "true",
        settings: %{}
      },
      %{
        name: "Github",
        slug: "github-datasource",
        enabled: "true",
        settings: %{
          "token" => %{
            "source" => "env",
            "value" => "GITHUB_TOKEN",
            "required" => true,
            "type" => "string"
          },
          "owner" => %{
            "type" => "string",
            "required" => true,
            "value" => "",
            "source" => "local"
          },
          "repository" => %{
            "type" => "string",
            "required" => true,
            "value" => "",
            "source" => "local"
          }
        }
      },
      %{
        name: "Weather",
        slug: "weather-api-datasource",
        enabled: "true",
        settings: %{
          "key" => %{
            "source" => "env",
            "type" => "string",
            "value" => "WEATHER_API_KEY",
            "required" => true
          }
        }
      },
      %{
        name: "Blameless",
        slug: "blameless-datasource",
        enabled: "true",
        settings: %{
          "client_id" => %{
            "type" => "string",
            "source" => "env",
            "value" => "BLAMELESS_CLIENT_ID",
            "required" => true
          },
          "client_secret" => %{
            "type" => "string",
            "source" => "env",
            "value" => "BLAMELESS_CLIENT_SECRET",
            "required" => true
          },
          "audience" => %{
            "type" => "string",
            "source" => "env",
            "value" => "BLAMELESS_AUDIENCE",
            "required" => true
          },
          "endpoint" => %{
            "source" => "env",
            "type" => "string",
            "value" => "BLAMELESS_ENDPOINT",
            "required" => true
          }
        }
      },
      %{
        name: "Wordpress",
        slug: "wordpress-datasource",
        enabled: "true",
        settings: %{
          "application_password" => %{
            "source" => "env",
            "type" => "string",
            "value" => "WORDPRESS_TEST_APP_PASSWORD",
            "required" => true
          },
          "url" => %{
            "type" => "string",
            "required" => true
          }
        }
      },
      %{
        name: "MergeStat",
        slug: "merge-stat-datasource",
        enabled: "true",
        settings: %{
          "repo" => %{
            "type" => "string",
            "required" => true,
            "source" => "local",
            "value" => ""
          },
          "limit" => %{
            "type" => "int",
            "required" => true,
            "source" => "local",
            "value" => 10
          }
        }
      },
      %{
        name: "Rollbar",
        slug: "rollbar-datasource",
        enabled: "true",
        settings: %{
          "env" => %{"source" => "local", "type" => "string", "value" => "production"},
          "limit" => %{"source" => "local", "type" => "int", "value" => 5},
          "status" => %{"source" => "local", "type" => "string", "value" => "active"},
          "token" => %{"type" => "string", "source" => "env", "value" => "ROLLBAR_TOKEN"}
        }
      }
    ]
    |> Enum.map(fn data ->
      insert(data)
    end)
  end

  defp insert(data) do
    Datasource.changeset(%Datasource{}, data)
    |> Repo.insert!(on_conflict: :nothing)
  end
end
