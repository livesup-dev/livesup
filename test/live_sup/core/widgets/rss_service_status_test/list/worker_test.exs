defmodule LiveSup.Test.Core.Widgets.RssServiceStatus.List.WorkerTest do
  use LiveSup.DataCase

  alias LiveSup.Core.Widgets.RssServiceStatus.List.Worker
  alias LiveSup.Core.Widgets.{WidgetManager, WorkerTaskSupervisor}
  alias LiveSup.Schemas.WidgetInstance

  describe "Rss Service Status widget" do
    @describetag :widget
    @describetag :rss_service_status_list_widget

    @widget_instance %WidgetInstance{
      id: "955ef326-ab34-4163-afa3-d2a30aff0d0c",
      settings: %{
        "services" => %{
          "source" => "local",
          "type" => "array",
          "value" => [
            %{
              "url" => "http://localhost:12344/github/history.rss",
              "icon" => "/images/widgets/logos/github.png",
              "name" => "Github"
            },
            %{
              "url" => "http://localhost:12355/quay/history.rss",
              "icon" => "/images/widgets/logos/quay.png",
              "name" => "Quay"
            }
          ]
        }
      },
      widget: %LiveSup.Schemas.Widget{
        worker_handler: "LiveSup.Core.Widgets.RssServiceStatus.List.Worker",
        settings: %{}
      },
      datasource_instance: %LiveSup.Schemas.DatasourceInstance{
        settings: %{},
        datasource: %LiveSup.Schemas.Datasource{
          settings: %{}
        }
      }
    }

    setup do
      WidgetManager.stop_widgets()

      # https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.Sandbox.html#module-shared-mode
      Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    end

    test "checking rss services status widget server" do
      bypass_github = Bypass.open(port: 12_344)
      bypass_quay = Bypass.open(port: 12_355)

      Bypass.expect(bypass_github, "GET", "/github/history.rss", fn conn ->
        Plug.Conn.resp(conn, 200, github_response())
      end)

      Bypass.expect(bypass_quay, "GET", "/quay/history.rss", fn conn ->
        Plug.Conn.resp(conn, 200, quay_response())
      end)

      {:ok, _pid} = WidgetManager.start_widget(@widget_instance)

      WorkerTaskSupervisor.wait_for_completion()

      data = Worker.get_data(@widget_instance)

      assert %LiveSup.Core.Widgets.WidgetData{
               data: [
                 %{
                   created_at: _,
                   created_at_ago: _,
                   icon: "/images/widgets/logos/github.png",
                   service_name: "Github",
                   status: :operational,
                   title: "Incident with GitHub Actions",
                   url: "https://www.githubstatus.com/incidents/tc051c121cs7"
                 },
                 %{
                   created_at: _,
                   created_at_ago: _,
                   icon: "/images/widgets/logos/quay.png",
                   service_name: "Quay",
                   status: :operational,
                   title: "quay.io read-only mode for database maintenance",
                   url: "https://status.quay.io/incidents/krngxv3xrsmn"
                 }
               ],
               state: :ready,
               title: "Rss Services Status",
               updated_in_minutes: _
             } = data
    end

    defp github_response() do
      """
      <?xml version="1.0" encoding="UTF-8"?>
      <rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
        <channel>
          <title>GitHub Status - Incident History</title>
          <link>https://www.githubstatus.com</link>
          <description>Statuspage</description>
          <pubDate>Tue, 11 Dec 2021 08:03:42 +0000</pubDate>
          <item>
            <title>Incident with GitHub Actions</title>
            <description>
      &lt;p&gt;&lt;small&gt;Dec &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;18:19&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Dec &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;15:06&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - We&apos;re currently observing increased failures impacting only self hosted runners in actions. We believe we have identified the issue and are attempting resolution&lt;/p&gt;&lt;p&gt;&lt;small&gt;Dec &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;14:56&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Actions.&lt;/p&gt;      </description>
            <pubDate>Fri, 10 Dec 2021 18:19:00 +0000</pubDate>
            <link>https://www.githubstatus.com/incidents/tc051c121cs7</link>
            <guid>https://www.githubstatus.com/incidents/tc051c121cs7</guid>
          </item>
          <item>
            <title>Incident with Codespaces</title>
            <description>
      &lt;p&gt;&lt;small&gt;Dec &lt;var data-var=&apos;date&apos;&gt; 8&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;19:00&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Dec &lt;var data-var=&apos;date&apos;&gt; 8&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;17:02&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Codespaces.&lt;/p&gt;      </description>
            <pubDate>Wed, 08 Dec 2021 19:00:19 +0000</pubDate>
            <link>https://www.githubstatus.com/incidents/y0ldt0scdrxf</link>
            <guid>https://www.githubstatus.com/incidents/y0ldt0scdrxf</guid>
          </item>
        </channel>
      </rss>
      """
    end

    defp quay_response() do
      """
      <?xml version="1.0" encoding="UTF-8"?>
      <rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
        <channel>
          <title>Quay.io Status - Incident History</title>
          <link>https://status.quay.io</link>
          <description>Statuspage</description>
          <pubDate>Tue, 14 Dec 2021 03:57:40 -0500</pubDate>
          <item>
            <title>quay.io read-only mode for database maintenance</title>
            <description>
      &lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt; 7&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;07:01&lt;/var&gt; EST&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Completed&lt;/strong&gt; - The scheduled maintenance has been completed.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt; 7&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;05:44&lt;/var&gt; EST&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Verifying&lt;/strong&gt; - Verification is currently underway for the maintenance items.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt; 7&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;03:00&lt;/var&gt; EST&lt;/small&gt;&lt;br&gt;&lt;strong&gt;In progress&lt;/strong&gt; - Scheduled maintenance is currently in progress. We will provide updates as necessary.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt; 2&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;09:29&lt;/var&gt; EDT&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Scheduled&lt;/strong&gt; - quay.io will go into read-only mode on Sunday, November 7, 2021 at UTC 8:00 for database maintenance. During this maintenance window, image pulls will continue to work, but builds and pushes will not be possible. This maintenance is expected to last no more than four hours.&lt;/p&gt;      </description>
            <pubDate>Sun, 07 Nov 2021 07:01:01 -0500</pubDate>
            <link>https://status.quay.io/incidents/krngxv3xrsmn</link>
            <guid>https://status.quay.io/incidents/krngxv3xrsmn</guid>
          </item>
          <item>
            <title>quay.io read-only mode for database maintenance</title>
            <description>
      &lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt; 1&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;10:19&lt;/var&gt; EDT&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Completed&lt;/strong&gt; - The quay.io database maintenance originally scheduled for November 1, 2021 has been postponed. More communications will follow about the new date as information becomes available.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt; 1&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;10:16&lt;/var&gt; EDT&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Scheduled&lt;/strong&gt; - We will be undergoing scheduled maintenance during this time.&lt;/p&gt;      </description>
            <pubDate>Mon, 01 Nov 2021 10:19:06 -0400</pubDate>
            <link>https://status.quay.io/incidents/s8chvpm01k15</link>
            <guid>https://status.quay.io/incidents/s8chvpm01k15</guid>
          </item>
        </channel>
      </rss>
      """
    end
  end
end
