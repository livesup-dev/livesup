defmodule LiveSup.Seeds.ProjectsSeeds do
  alias LiveSup.Repo
  alias LiveSup.Schemas.{Project, Dashboard}
  alias LiveSup.Core.{Datasources, Widgets, Teams}
  def seed, do: insert_data()

  defp insert_data do
    # TODO: This is terrible. Please refactor
    rss_datasource = Datasources.get_by_slug!("rss-datasource")
    jira_datasource = Datasources.get_by_slug!("jira-datasource")
    github_datasource = Datasources.get_by_slug!("github-datasource")
    blameless_datasource = Datasources.get_by_slug!("blameless-datasource")
    lord_of_the_ring_datasource = Datasources.get_by_slug!("lord-of-ring-datasource")
    merge_stat_datasource = Datasources.get_by_slug!("merge-stat-datasource")
    rollbar_datasource = Datasources.get_by_slug!("rollbar-datasource")
    weather_datasource = Datasources.get_by_slug!("weather-api-datasource")
    chuck_datasource = Datasources.get_by_slug!("chuck-norries-datasource")
    local_datasource = Datasources.get_by_slug!("local-datasource")

    {:ok, weather_datasource_instance} = Datasources.create_instance(weather_datasource)
    {:ok, rss_datasource_instance} = Datasources.create_instance(rss_datasource)
    {:ok, chuck_datasource_instance} = Datasources.create_instance(chuck_datasource)

    {:ok, blameless_datasource_instance} = Datasources.create_instance(blameless_datasource)

    {:ok, lord_of_the_ring_datasource_instance} =
      Datasources.create_instance(lord_of_the_ring_datasource)

    {:ok, jira_datasource_instance} = Datasources.create_instance(jira_datasource)

    {:ok, github_datasource_instance} = Datasources.create_instance(github_datasource)

    {:ok, merge_stat_datasource_instance} = Datasources.create_instance(merge_stat_datasource)

    {:ok, rollbar_datasource_instance} = Datasources.create_instance(rollbar_datasource)

    {:ok, local_datasource_instance} = Datasources.create_instance(local_datasource)

    weather_widget = get_widget_by_slug("weather")
    chuck_widget = get_widget_by_slug("chuck-norris-joke")
    rss_service_status_widget = get_widget_by_slug("rss-service-status-single")
    rss_service_status_list_widget = get_widget_by_slug("rss-service-status-list")
    lord_of_the_ring_widget = get_widget_by_slug("lord-of-the-ring-quote")
    blameless_current_incidents_widget = get_widget_by_slug("blameless-current-incidents")
    blameless_last_incidents_widget = get_widget_by_slug("blameless-last-incidents")
    blameless_incidents_by_type_widget = get_widget_by_slug("blameless-incidents-by-type")
    blameless_incidents_by_type_severity = get_widget_by_slug("blameless-incidents-by-severity")
    blameless_incidents_by_date_widget = get_widget_by_slug("blameless-incidents-by-date")
    jira_current_sprint_widget = get_widget_by_slug("jira-current-sprint")
    github_pull_requests_widget = get_widget_by_slug("github-pull-requests")
    merge_stat_github_authors_widget = get_widget_by_slug("merge-stat-github-authors")
    rollbar_list_of_issues_widget = get_widget_by_slug("rollbar-list-of-isuess")
    team_members_widget = get_widget_by_slug("team-members")
    metrics_goal_widget = get_widget_by_slug("metrics-goal")

    create_private_project()

    team_a = Teams.get_by_slug!("team-a")

    dashboards = [
      %{
        dashboard: %{
          name: "My Dashboard",
          default: true
        },
        widgets: [
          %{
            widget: weather_widget,
            settings: %{
              "location" => %{source: "local", type: "string", value: "Mahon"}
            },
            datasource_instance: weather_datasource_instance
          },
          %{
            widget: chuck_widget,
            settings: %{},
            datasource_instance: chuck_datasource_instance
          },
          %{
            widget: rss_service_status_widget,
            settings: %{
              "url" => %{
                source: "local",
                type: "string",
                value: "https://www.githubstatus.com/history.rss"
              },
              "title" => %{source: "local", type: "string", value: "Github"},
              "icon" => %{
                source: "local",
                type: "string",
                value: "/images/widgets/logos/github.png"
              }
            },
            datasource_instance: rss_datasource_instance
          },
          %{
            widget: rss_service_status_widget,
            settings: %{
              "url" => %{
                source: "local",
                type: "string",
                value: "https://status.rollbar.com/history.rss"
              },
              "title" => %{source: "local", type: "string", value: "Rollbar"},
              "icon" => %{
                source: "local",
                type: "string",
                value: "/images/widgets/logos/rollbar.png"
              }
            },
            datasource_instance: rss_datasource_instance
          },
          %{
            widget: rss_service_status_widget,
            settings: %{
              "url" => %{
                source: "local",
                type: "string",
                value: "https://status.quay.io/history.rss"
              },
              "title" => %{source: "local", type: "string", value: "Quay"},
              "icon" => %{
                source: "local",
                type: "string",
                value: "/images/widgets/logos/quay.png"
              }
            },
            datasource_instance: rss_datasource_instance
          },
          %{
            widget: rss_service_status_list_widget,
            settings: %{
              "services" => %{
                source: "local",
                type: "array",
                value: [
                  %{
                    "url" => "https://status.quay.io/history.rss",
                    "icon" => "/images/widgets/logos/quay.png",
                    "name" => "Quay"
                  },
                  %{
                    "url" => "https://status.rollbar.com/history.rss",
                    "icon" => "/images/widgets/logos/rollbar.png",
                    "name" => "Rollbar"
                  },
                  %{
                    "url" => "https://www.githubstatus.com/history.rss",
                    "icon" => "/images/widgets/logos/github.png",
                    "name" => "Github"
                  },
                  %{
                    "url" => "https://status.launchdarkly.com/history.rss",
                    "icon" => "/images/widgets/logos/launchdarkly.png",
                    "name" => "Launchdarkly"
                  },
                  %{
                    "url" => "https://status.jumpcloud.com/history.rss",
                    "icon" => "/images/widgets/logos/jumpcloud.png",
                    "name" => "Jumpcloud"
                  }
                ]
              }
            },
            datasource_instance: rss_datasource_instance
          },
          %{
            widget: jira_current_sprint_widget,
            settings: %{
              "board_id" => %{source: "local", type: "string", value: "145"}
            },
            datasource_instance: jira_datasource_instance
          },
          %{
            widget: lord_of_the_ring_widget,
            settings: %{},
            datasource_instance: lord_of_the_ring_datasource_instance
          },
          %{
            widget: github_pull_requests_widget,
            settings: %{
              "owner" => %{source: "local", type: "string", value: "phoenixframework"},
              "repository" => %{source: "local", type: "string", value: "phoenix"},
              "state" => %{source: "local", type: "string", value: "closed"}
            },
            datasource_instance: github_datasource_instance
          },
          %{
            widget: blameless_current_incidents_widget,
            settings: %{},
            datasource_instance: blameless_datasource_instance
          },
          %{
            widget: blameless_last_incidents_widget,
            settings: %{},
            datasource_instance: blameless_datasource_instance
          },
          %{
            widget: blameless_incidents_by_type_widget,
            settings: %{},
            datasource_instance: blameless_datasource_instance
          },
          %{
            widget: blameless_incidents_by_type_severity,
            settings: %{},
            datasource_instance: blameless_datasource_instance
          },
          %{
            widget: blameless_incidents_by_date_widget,
            settings: %{},
            datasource_instance: blameless_datasource_instance
          },
          %{
            widget: merge_stat_github_authors_widget,
            settings: %{
              "repo" => %{
                source: "local",
                type: "string",
                value: "https://github.com/livebook-dev/livebook"
              },
              "limit" => %{
                source: "local",
                type: "int",
                value: 5
              }
            },
            datasource_instance: merge_stat_datasource_instance
          }
        ]
      },
      %{
        dashboard: %{
          name: "My Team",
          default: false
        },
        widgets: [
          %{
            widget: weather_widget,
            settings: %{
              "location" => %{source: "local", type: "string", value: "Buenos Aires"}
            },
            datasource_instance: weather_datasource_instance
          },
          %{
            widget: chuck_widget,
            settings: %{},
            datasource_instance: chuck_datasource_instance
          },
          %{
            widget: rollbar_list_of_issues_widget,
            settings: %{},
            datasource_instance: rollbar_datasource_instance
          },
          %{
            widget: team_members_widget,
            settings: %{
              "team" => %{"source" => "local", "string" => "string", "value" => team_a.id}
            },
            datasource_instance: local_datasource_instance
          },
          %{
            widget: metrics_goal_widget,
            settings: %{
              "metric" => %{"source" => "local", "string" => "string", "value" => "test"}
            },
            datasource_instance: local_datasource_instance
          }
        ]
      }
    ]

    [
      %{
        name: "My Stuff",
        # TODO: We need to find a better name
        slug: "my-stuff",
        internal: true,
        default: true
      }
    ]
    |> Enum.map(fn data ->
      project = get_or_create_project(data)

      dashboards
      |> Enum.each(fn dashboard_attrs ->
        dashboard =
          Dashboard.changeset(%Dashboard{}, %{
            project_id: project.id,
            name: dashboard_attrs[:dashboard][:name],
            default: dashboard_attrs[:dashboard][:default]
          })
          |> Repo.insert!(on_conflict: :nothing)

        dashboard_attrs[:widgets]
        |> Enum.each(fn widget_data ->
          {:ok, widget_instance} =
            LiveSup.Core.Widgets.create_instance(
              widget_data[:widget],
              widget_data[:datasource_instance],
              widget_data[:settings]
            )

          LiveSup.Core.Dashboards.add_widget(dashboard, widget_instance)
        end)
      end)
    end)
  end

  defp get_or_create_project(data) do
    LiveSup.Queries.ProjectQuery.get_internal_default_project() ||
      Project.changeset(%Project{}, data)
      |> Repo.insert!(on_conflict: :nothing)
  end

  defp create_private_project() do
    Project.changeset(%Project{}, %{
      id: "c4cf318c-8098-4ed8-b21c-5286aa18025b",
      name: "Private project",
      slug: "private-project"
    })
    |> Repo.insert!(on_conflict: :nothing)
  end

  defp get_widget_by_slug(slug) do
    Widgets.get_by_slug!(slug)
  end
end
