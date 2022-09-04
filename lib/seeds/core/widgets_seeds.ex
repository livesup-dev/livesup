defmodule LiveSup.Seeds.Core.WidgetsSeeds do
  alias LiveSup.Repo
  alias LiveSup.Schemas.Widget
  alias LiveSup.Core.Datasources

  def seed, do: insert_data()

  defp insert_data do
    [
      %{
        datasource_slug: "weather-api-datasource",
        attrs: &weather_widget_attrs/1
      },
      %{
        datasource_slug: "chuck-norries-datasource",
        attrs: &chuck_widget_attrs/1
      },
      %{
        datasource_slug: "rss-datasource",
        attrs: &rss_service_status_widget_attrs/1
      },
      %{
        datasource_slug: "rss-datasource",
        attrs: &rss_service_status_list_widget_attrs/1
      },
      %{
        datasource_slug: "blameless-datasource",
        attrs: &blameless_current_incidents_widget_attrs/1
      },
      %{
        datasource_slug: "blameless-datasource",
        attrs: &blameless_last_incidents_widget_attrs/1
      },
      %{
        datasource_slug: "blameless-datasource",
        attrs: &blameless_incidents_by_type_widget_attrs/1
      },
      %{
        datasource_slug: "blameless-datasource",
        attrs: &blameless_incidents_by_severity_widget_attrs/1
      },
      %{
        datasource_slug: "blameless-datasource",
        attrs: &blameless_incidents_by_date_widget_attrs/1
      },
      %{
        datasource_slug: "jira-datasource",
        attrs: &jira_current_sprint_widget_attrs/1
      },
      %{
        datasource_slug: "jira-datasource",
        attrs: &jira_current_sprint_stats_widget_attrs/1
      },
      %{
        datasource_slug: "jira-datasource",
        attrs: &jira_list_of_issues_widget_attrs/1
      },
      %{
        datasource_slug: "github-datasource",
        attrs: &github_pull_requests_widget_attrs/1
      },
      %{
        datasource_slug: "lord-of-ring-datasource",
        attrs: &lord_of_the_ring_widget_attrs/1
      },
      %{
        datasource_slug: "wordpress-datasource",
        attrs: &wordpress_directory_sizes_widget_attrs/1
      },
      %{
        datasource_slug: "wordpress-datasource",
        attrs: &wordpress_core_health_status_widget_attrs/1
      },
      %{
        datasource_slug: "merge-stat-datasource",
        attrs: &merge_stat_github_authors_widget_attrs/1
      },
      %{
        datasource_slug: "rollbar-datasource",
        attrs: &rollbar_list_of_issues_widget_attrs/1
      },
      %{
        datasource_slug: "local-datasource",
        attrs: &team_members_widget_attrs/1
      },
      %{
        datasource_slug: "local-datasource",
        attrs: &goal_widget_attrs/1
      },
      %{
        datasource_slug: "local-datasource",
        attrs: &gauge_widget_attrs/1
      },
      %{
        datasource_slug: "local-datasource",
        attrs: &bullet_gauge_widget_attrs/1
      },
      %{
        datasource_slug: "pager-duty-datasource",
        attrs: &pager_duty_on_call_widget_attrs/1
      },
      %{
        datasource_slug: "datadog-datasource",
        attrs: &datadog_scalar_widget_attrs/1
      },
      %{
        datasource_slug: "local-datasource",
        attrs: &note_widget_attrs/1
      }
    ]
    |> Enum.each(fn widget ->
      widget |> build_and_create_widget()
    end)
  end

  defp build_and_create_widget(%{datasource_slug: nil} = widget) do
    widget[:attrs].()
    |> create_widget()
  end

  defp build_and_create_widget(%{datasource_slug: _} = widget) do
    datasource = Datasources.get_by_slug!(widget[:datasource_slug])

    datasource
    |> widget[:attrs].()
    |> create_widget()
  end

  defp create_widget(attrs) do
    Widget.changeset(%Widget{}, attrs)
    |> Repo.insert!(on_conflict: :nothing, conflict_target: :slug)
  end

  defp team_members_widget_attrs(datasource) do
    %{
      name: "Team Members",
      slug: "team-members",
      enabled: true,
      global: true,
      feature_image_url: "/images/widgets/team-members.png",
      ui_handler: "LiveSupWeb.Live.Widgets.TeamMembersLive",
      worker_handler: "LiveSup.Core.Widgets.TeamMembers.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 5},
        "team" => %{"source" => "local", "string" => "string", "value" => ""}
      },
      datasource_id: datasource.id
    }
  end

  defp pager_duty_on_call_widget_attrs(datasource) do
    %{
      name: "On Call",
      slug: "pager-duty-on-call",
      enabled: true,
      global: true,
      feature_image_url: "/images/widgets/pager-duty-on-call",
      ui_handler: "LiveSupWeb.Live.Widgets.PagerDuty.OnCallLive",
      worker_handler: "LiveSup.Core.Widgets.PagerDuty.OnCall.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 600},
        "schedule_ids" => %{"source" => "local", "string" => "string", "value" => ""}
      },
      datasource_id: datasource.id
    }
  end

  defp datadog_scalar_widget_attrs(datasource) do
    %{
      name: "Datadog Scalar",
      slug: "datadog-scalar",
      enabled: true,
      global: true,
      feature_image_url: "/images/widgets/datadog-scalar",
      ui_handler: "LiveSupWeb.Live.Widgets.Datadog.ScalarLive",
      worker_handler: "LiveSup.Core.Widgets.Datadog.Scalar.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 36_000},
        "query" => %{"source" => "local", "type" => "string", "value" => ""},
        "n_days" => %{"source" => "local", "type" => "int", "value" => "7"},
        "target" => %{"source" => "local", "type" => "string", "value" => ""},
        "unit" => %{"source" => "local", "type" => "string", "value" => ""}
      },
      datasource_id: datasource.id
    }
  end

  defp note_widget_attrs(datasource) do
    %{
      name: "Note",
      slug: "note",
      enabled: true,
      global: true,
      feature_image_url: "/images/widgets/note",
      ui_handler: "LiveSupWeb.Live.Widgets.NoteLive",
      worker_handler: "LiveSup.Core.Widgets.Note.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 36_000},
        "note" => %{"source" => "local", "type" => "string", "value" => ""}
      },
      datasource_id: datasource.id
    }
  end

  defp goal_widget_attrs(datasource) do
    %{
      name: "Goal",
      slug: "metrics-goal",
      enabled: true,
      global: true,
      feature_image_url: "/images/widgets/metric-goal.png",
      ui_handler: "LiveSupWeb.Live.Widgets.Metrics.GoalLive",
      worker_handler: "LiveSup.Core.Widgets.Metrics.Goal.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 60},
        "metric" => %{"source" => "local", "string" => "string", "value" => ""}
      },
      datasource_id: datasource.id
    }
  end

  defp bullet_gauge_widget_attrs(datasource) do
    %{
      name: "Bullet Gauge",
      slug: "metrics-bullet-gauge",
      enabled: true,
      global: true,
      feature_image_url: "/images/widgets/metric-gauge.png",
      ui_handler: "LiveSupWeb.Live.Widgets.Metrics.BulletGaugeLive",
      worker_handler: "LiveSup.Core.Widgets.Metrics.Goal.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 60},
        "metric" => %{"source" => "local", "string" => "string", "value" => ""}
      },
      datasource_id: datasource.id
    }
  end

  defp gauge_widget_attrs(datasource) do
    %{
      name: "Gauge",
      slug: "metrics-gauge",
      enabled: true,
      global: true,
      feature_image_url: "/images/widgets/metric-gauge.png",
      ui_handler: "LiveSupWeb.Live.Widgets.Metrics.GaugeLive",
      worker_handler: "LiveSup.Core.Widgets.Metrics.Goal.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 60},
        "metric" => %{"source" => "local", "string" => "string", "value" => ""}
      },
      datasource_id: datasource.id
    }
  end

  defp blameless_current_incidents_widget_attrs(datasource) do
    %{
      name: "Blameless current incidents",
      slug: "blameless-current-incidents",
      enabled: true,
      global: true,
      feature_image_url: "/images/widgets/blameless-current-incidents.png",
      ui_handler: "LiveSupWeb.Live.Widgets.Blameless.CurrentIncidentsLive",
      worker_handler: "LiveSup.Core.Widgets.Blameless.CurrentIncidents.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 10}
      },
      datasource_id: datasource.id
    }
  end

  defp blameless_last_incidents_widget_attrs(datasource) do
    %{
      name: "Blameless last incidents",
      slug: "blameless-last-incidents",
      feature_image_url: "/images/widgets/blameless-last-incidents.png",
      enabled: true,
      global: true,
      ui_handler: "LiveSupWeb.Live.Widgets.Blameless.LastIncidentsLive",
      worker_handler: "LiveSup.Core.Widgets.Blameless.LastIncidents.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 10},
        "limit" => %{"source" => "local", "type" => "int", "value" => 5}
      },
      datasource_id: datasource.id
    }
  end

  defp blameless_incidents_by_type_widget_attrs(datasource) do
    %{
      name: "Blameless Incidents by type",
      slug: "blameless-incidents-by-type",
      feature_image_url: "/images/widgets/blameless-incidents-by-type.png",
      enabled: true,
      global: true,
      ui_handler: "LiveSupWeb.Live.Widgets.Blameless.IncidentsByTypeLive",
      worker_handler: "LiveSup.Core.Widgets.Blameless.IncidentsByType.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 60},
        "limit" => %{"source" => "local", "type" => "int", "value" => 10}
      },
      datasource_id: datasource.id
    }
  end

  defp blameless_incidents_by_severity_widget_attrs(datasource) do
    %{
      name: "Blameless Incidents by Severity",
      slug: "blameless-incidents-by-severity",
      feature_image_url: "/images/widgets/blameless-incidents-by-severity.png",
      enabled: true,
      global: true,
      ui_handler: "LiveSupWeb.Live.Widgets.Blameless.IncidentsBySeverityLive",
      worker_handler: "LiveSup.Core.Widgets.Blameless.IncidentsBySeverity.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 60},
        "limit" => %{"source" => "local", "type" => "int", "value" => 10}
      },
      datasource_id: datasource.id
    }
  end

  defp blameless_incidents_by_date_widget_attrs(datasource) do
    %{
      name: "Blameless Incidents by date",
      slug: "blameless-incidents-by-date",
      feature_image_url: "/images/widgets/blameless-incidents-by-date.png",
      enabled: true,
      global: true,
      ui_handler: "LiveSupWeb.Live.Widgets.Blameless.IncidentsByDateLive",
      worker_handler: "LiveSup.Core.Widgets.Blameless.IncidentsByDate.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 60},
        "limit" => %{"source" => "local", "type" => "int", "value" => 50}
      },
      datasource_id: datasource.id
    }
  end

  defp weather_widget_attrs(http_datasource) do
    %{
      name: "Weather",
      slug: "weather",
      enabled: true,
      global: true,
      feature_image_url: "/images/widgets/weather.png",
      ui_handler: "LiveSupWeb.Live.Widgets.WeatherLive",
      worker_handler: "LiveSup.Core.Widgets.Weather.Worker",
      labels: [],
      settings: %{
        # 12 hours
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 43_200},
        "location" => %{"source" => "local", "type" => "string", "value" => ""}
      },
      datasource_id: http_datasource.id
    }
  end

  defp lord_of_the_ring_widget_attrs(lord_of_the_ring_datasource) do
    %{
      name: "LordOfTheRingQuote",
      slug: "lord-of-the-ring-quote",
      enabled: true,
      global: true,
      feature_image_url: "/images/widgets/lord-of-the-ring-quote.png",
      ui_handler: "LiveSupWeb.Live.Widgets.LordOfTheRingQuoteLive",
      worker_handler: "LiveSup.Core.Widgets.LordOfTheRingQuote.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 5}
      },
      datasource_id: lord_of_the_ring_datasource.id
    }
  end

  defp rss_service_status_widget_attrs(rss_datasource) do
    %{
      name: "Rss Service Status",
      slug: "rss-service-status-single",
      feature_image_url: "/images/widgets/rss-service-status-single.png",
      enabled: true,
      global: true,
      ui_handler: "LiveSupWeb.Live.Widgets.RssServiceStatus.SingleLive",
      worker_handler: "LiveSup.Core.Widgets.RssServiceStatus.Single.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{
          "source" => "local",
          "type" => "int",
          "value" => 60
        },
        "url" => %{
          "source" => "local",
          "type" => "string",
          "value" => ""
        },
        "title" => %{"source" => "local", "type" => "string", "value" => ""},
        "icon" => %{
          "source" => "local",
          "type" => "string",
          "value" => ""
        }
      },
      datasource_id: rss_datasource.id
    }
  end

  defp rss_service_status_list_widget_attrs(rss_datasource) do
    %{
      name: "Rss Services Status",
      slug: "rss-service-status-list",
      feature_image_url: "/images/widgets/rss-service-status-list.png",
      enabled: true,
      global: true,
      ui_handler: "LiveSupWeb.Live.Widgets.RssServiceStatus.ListLive",
      worker_handler: "LiveSup.Core.Widgets.RssServiceStatus.List.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 60},
        "services" => %{
          source: "local",
          type: "array",
          value: []
        }
      },
      datasource_id: rss_datasource.id
    }
  end

  defp jira_current_sprint_stats_widget_attrs(jira_datasource) do
    %{
      name: "Jira Current Sprint Stats",
      slug: "jira-current-sprint-stats",
      feature_image_url: "/images/widgets/jira-current-sprint-stats.png",
      enabled: true,
      global: true,
      ui_handler: "LiveSupWeb.Live.Widgets.Jira.CurrentSprintStatsLive",
      worker_handler: "LiveSup.Core.Widgets.Jira.CurrentSprintStats.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 120},
        "board_id" => %{"source" => "local", "type" => "string", "value" => "145"}
      },
      datasource_id: jira_datasource.id
    }
  end

  defp jira_list_of_issues_widget_attrs(jira_datasource) do
    %{
      name: "Jira list of issues",
      slug: "jira-list-of-issues",
      feature_image_url: "/images/widgets/jira-list-of-issues.png",
      enabled: true,
      global: false,
      ui_handler: "LiveSupWeb.Live.Widgets.Jira.ListOfIssuesLive",
      worker_handler: "LiveSup.Core.Widgets.Jira.ListOfIssues.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 120}
      },
      datasource_id: jira_datasource.id
    }
  end

  defp jira_current_sprint_widget_attrs(jira_datasource) do
    %{
      name: "Jira Current Sprint",
      slug: "jira-current-sprint",
      feature_image_url: "/images/widgets/jira-current-sprint.png",
      enabled: true,
      global: true,
      ui_handler: "LiveSupWeb.Live.Widgets.Jira.CurrentSprintLive",
      worker_handler: "LiveSup.Core.Widgets.Jira.CurrentSprint.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 120},
        "board_id" => %{"source" => "local", "type" => "string", "value" => "145"}
      },
      datasource_id: jira_datasource.id
    }
  end

  defp chuck_widget_attrs(http_datasource) do
    %{
      name: "Chuck Norris's Joke",
      slug: "chuck-norris-joke",
      feature_image_url: "/images/widgets/chuck-norris-joke.png",
      enabled: true,
      global: true,
      ui_handler: "LiveSupWeb.Live.Widgets.ChuckNorrisLive",
      worker_handler: "LiveSup.Core.Widgets.ChuckNorrisJoke.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 120}
      },
      datasource_id: http_datasource.id
    }
  end

  defp github_pull_requests_widget_attrs(github_datasource) do
    %{
      name: "Github Pull Requests",
      slug: "github-pull-requests",
      feature_image_url: "/images/widgets/github-pull-requests.png",
      enabled: true,
      global: true,
      ui_handler: "LiveSupWeb.Live.Widgets.Github.PullRequestsLive",
      worker_handler: "LiveSup.Core.Widgets.Github.PullRequests.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 60},
        "limit" => %{"source" => "local", "type" => "int", "value" => 10}
      },
      ui_settings: %{"size" => 1},
      datasource_id: github_datasource.id
    }
  end

  def wordpress_directory_sizes_widget_attrs(datasource) do
    %{
      name: "Wordpress Directory Sizes",
      slug: "wordpress-directory-sizes",
      feature_image_url: "/images/widgets/wordpress-directory-sizes.png",
      enabled: true,
      global: true,
      ui_handler: "LiveSupWeb.Live.Widgets.Wordpress.DirectorySizesLive",
      worker_handler: "LiveSup.Core.Widgets.Wordpress.DirectorySizes.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 43_200}
      },
      datasource_id: datasource.id
    }
  end

  def wordpress_core_health_status_widget_attrs(datasource) do
    %{
      name: "Wordpress Core Health Status",
      slug: "wordpress-core-health-status",
      feature_image_url: "/images/widgets/wordpress-core-health-status.png",
      enabled: true,
      global: true,
      ui_handler: "LiveSupWeb.Live.Widgets.Wordpress.CoreHealthStatusLive",
      worker_handler: "LiveSup.Core.Widgets.Wordpress.CoreHealthStatus.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 43_200}
      },
      datasource_id: datasource.id
    }
  end

  def merge_stat_github_authors_widget_attrs(datasource) do
    %{
      name: "Merge Stat - Github authors",
      slug: "merge-stat-github-authors",
      feature_image_url: "/images/widgets/merge-stat-github-authors.png",
      enabled: true,
      global: true,
      ui_handler: "LiveSupWeb.Live.Widgets.MergeStat.CommitsByAuthorsLive",
      worker_handler: "LiveSup.Core.Widgets.MergeStat.CommitsByAuthor.Worker",
      labels: [],
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 600}
      },
      datasource_id: datasource.id
    }
  end

  def rollbar_list_of_issues_widget_attrs(datasource) do
    %{
      name: "Rollbar - List of issues",
      slug: "rollbar-list-of-isuess",
      feature_image_url: "/images/widgets/rollbar-list-of-isuess.png",
      enabled: true,
      global: true,
      ui_handler: "LiveSupWeb.Live.Widgets.Rollbar.ListOfIssuesLive",
      worker_handler: "LiveSup.Core.Widgets.Rollbar.ListOfIssues.Worker",
      labels: [],
      ui_settings: %{"size" => 2},
      settings: %{
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 10}
      },
      datasource_id: datasource.id
    }
  end
end
