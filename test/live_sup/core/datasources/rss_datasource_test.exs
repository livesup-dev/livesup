defmodule LiveSup.Test.Core.Datasources.RssDatasourceTest do
  use LiveSup.DataCase, async: false

  alias LiveSup.Core.Datasources.RssDatasource

  @response """
  <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
      <channel>
        <title>GitHub Status - Incident History</title>
        <link>https://www.githubstatus.com</link>
        <description>Statuspage</description>
        <pubDate>Tue, 14 Dec 2021 08:03:42 +0000</pubDate>
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

  describe "RssDatasource" do
    @describetag :datasource
    @describetag :rss_datasource

    setup do
      bypass = Bypass.open()
      {:ok, bypass: bypass}
    end

    test "Get data from rss endpoint", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/test.com", fn conn ->
        Plug.Conn.resp(conn, 200, @response)
      end)

      {:ok, data} = RssDatasource.fetch(endpoint_url(bypass.port, "test.com"))

      assert "Statuspage" == data[:description]
    end

    test "Fail to get data from http endpoint", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/test.com", fn conn ->
        Plug.Conn.resp(conn, 500, "Something is broken")
      end)

      response = RssDatasource.fetch(endpoint_url(bypass.port, "test.com"))

      assert {
               :error,
               "Something is broken"
             } == response
    end
  end

  defp endpoint_url(port, endpoint), do: "http://localhost:#{port}/#{endpoint}"
end
