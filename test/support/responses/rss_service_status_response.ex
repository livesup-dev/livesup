defmodule LiveSup.Test.Support.Responses.RssServiceStatusResponse do
  def get() do
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
      <channel>
        <title>GitHub Status - Incident History</title>
        <link>https://www.githubstatus.com</link>
        <description>Statuspage</description>
        <pubDate>Wed, 13 Oct 2021 11:34:41 +0000</pubDate>
        <item>
          <title>Incident with GitHub Actions</title>
          <description>
    &lt;p&gt;&lt;small&gt;Oct &lt;var data-var=&apos;date&apos;&gt;13&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;11:34&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Oct &lt;var data-var=&apos;date&apos;&gt;13&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;11:02&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Mitigation has been applied and we are starting to see recovery in Windows jobs. Jobs which failed can be re-run manually.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Oct &lt;var data-var=&apos;date&apos;&gt;13&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;09:44&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Currently investigating inability to process Windows jobs. Linux and Mac jobs are not impacted.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Oct &lt;var data-var=&apos;date&apos;&gt;13&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;08:46&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Actions.&lt;/p&gt;      </description>
          <pubDate>Wed, 13 Oct 2021 11:34:34 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/81lpnf07bm1q</link>
          <guid>https://www.githubstatus.com/incidents/81lpnf07bm1q</guid>
        </item>
        <item>
          <title>Incident with Codespaces</title>
          <description>
    &lt;p&gt;&lt;small&gt;Oct &lt;var data-var=&apos;date&apos;&gt; 9&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;17:40&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Oct &lt;var data-var=&apos;date&apos;&gt; 9&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;14:49&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Codespaces.&lt;/p&gt;      </description>
          <pubDate>Sat, 09 Oct 2021 17:40:19 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/ttkqsqrdj2kn</link>
          <guid>https://www.githubstatus.com/incidents/ttkqsqrdj2kn</guid>
        </item>
        <item>
          <title>Incident with Codespaces</title>
          <description>
    &lt;p&gt;&lt;small&gt;Oct &lt;var data-var=&apos;date&apos;&gt; 8&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;18:55&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Oct &lt;var data-var=&apos;date&apos;&gt; 8&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;17:45&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Codespaces is now experiencing degraded availability. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Oct &lt;var data-var=&apos;date&apos;&gt; 8&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;17:43&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Codespaces.&lt;/p&gt;      </description>
          <pubDate>Fri, 08 Oct 2021 18:55:28 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/vlt8clqxfb8f</link>
          <guid>https://www.githubstatus.com/incidents/vlt8clqxfb8f</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions</title>
          <description>
    &lt;p&gt;&lt;small&gt;Oct &lt;var data-var=&apos;date&apos;&gt; 6&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;14:05&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Oct &lt;var data-var=&apos;date&apos;&gt; 6&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;13:22&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Actions.&lt;/p&gt;      </description>
          <pubDate>Wed, 06 Oct 2021 14:05:09 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/1096gcjqz3pb</link>
          <guid>https://www.githubstatus.com/incidents/1096gcjqz3pb</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions, Git Operations, and GitHub Packages</title>
          <description>
    &lt;p&gt;&lt;small&gt;Oct &lt;var data-var=&apos;date&apos;&gt; 5&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;16:30&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Oct &lt;var data-var=&apos;date&apos;&gt; 5&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;15:10&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Git Operations is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Oct &lt;var data-var=&apos;date&apos;&gt; 5&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;14:56&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Packages is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Oct &lt;var data-var=&apos;date&apos;&gt; 5&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;14:21&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Git Operations is experiencing degraded performance. We are continuing to investigate.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Oct &lt;var data-var=&apos;date&apos;&gt; 5&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;13:45&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Packages is experiencing degraded performance. We are continuing to investigate.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Oct &lt;var data-var=&apos;date&apos;&gt; 5&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;13:45&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Actions.&lt;/p&gt;      </description>
          <pubDate>Tue, 05 Oct 2021 16:30:19 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/bdbzpz7qxmbx</link>
          <guid>https://www.githubstatus.com/incidents/bdbzpz7qxmbx</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions</title>
          <description>
    &lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt;28&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;03:05&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt;28&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;02:20&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Actions.&lt;/p&gt;      </description>
          <pubDate>Tue, 28 Sep 2021 03:05:51 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/rgkr7yjqv6gj</link>
          <guid>https://www.githubstatus.com/incidents/rgkr7yjqv6gj</guid>
        </item>
        <item>
          <title>Incident with Codespaces and GitHub Pages</title>
          <description>
    &lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt;23&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;01:51&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt;23&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;00:57&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Pages is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt;23&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;00:48&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Pages is experiencing degraded performance. We are continuing to investigate.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt;22&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;21:13&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Codespaces.&lt;/p&gt;      </description>
          <pubDate>Thu, 23 Sep 2021 01:51:51 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/gptb0dcy01nj</link>
          <guid>https://www.githubstatus.com/incidents/gptb0dcy01nj</guid>
        </item>
        <item>
          <title>Incident with Webhooks</title>
          <description>
    &lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt;20&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;21:27&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt;20&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;21:06&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Webhooks.&lt;/p&gt;      </description>
          <pubDate>Mon, 20 Sep 2021 21:27:36 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/nf8sggv27xy4</link>
          <guid>https://www.githubstatus.com/incidents/nf8sggv27xy4</guid>
        </item>
        <item>
          <title>Incident with GitHub Packages</title>
          <description>
    &lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt;20&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;14:02&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt;20&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;12:29&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Packages.&lt;/p&gt;      </description>
          <pubDate>Mon, 20 Sep 2021 14:02:19 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/vlbr8z458fq0</link>
          <guid>https://www.githubstatus.com/incidents/vlbr8z458fq0</guid>
        </item>
        <item>
          <title>Incident with GitHub Packages and Webhooks</title>
          <description>
    &lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt;15&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;06:42&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt;15&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;06:32&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Packages is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt;15&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;05:36&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Packages is experiencing degraded performance. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt;15&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;05:35&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Webhooks.&lt;/p&gt;      </description>
          <pubDate>Wed, 15 Sep 2021 06:42:29 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/c63xqykh321z</link>
          <guid>https://www.githubstatus.com/incidents/c63xqykh321z</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions</title>
          <description>
    &lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt; 7&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;17:20&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt; 7&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;16:48&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Actions.&lt;/p&gt;      </description>
          <pubDate>Tue, 07 Sep 2021 17:20:11 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/646hwwprmv3p</link>
          <guid>https://www.githubstatus.com/incidents/646hwwprmv3p</guid>
        </item>
        <item>
          <title>Incident with Codespaces</title>
          <description>
    &lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt; 2&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;18:34&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Sep &lt;var data-var=&apos;date&apos;&gt; 2&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;12:56&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Codespaces.&lt;/p&gt;      </description>
          <pubDate>Thu, 02 Sep 2021 18:34:40 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/lfvwm5qydw6r</link>
          <guid>https://www.githubstatus.com/incidents/lfvwm5qydw6r</guid>
        </item>
        <item>
          <title>Incident with GitHub Packages</title>
          <description>
    &lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;28&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;03:43&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;28&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;02:32&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Packages.&lt;/p&gt;      </description>
          <pubDate>Sat, 28 Aug 2021 03:43:22 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/8kwfpsps93z0</link>
          <guid>https://www.githubstatus.com/incidents/8kwfpsps93z0</guid>
        </item>
        <item>
          <title>Incident with GitHub Packages</title>
          <description>
    &lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;13:12&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;12:25&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Packages.&lt;/p&gt;      </description>
          <pubDate>Fri, 27 Aug 2021 13:12:49 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/wsh4dvm6x81k</link>
          <guid>https://www.githubstatus.com/incidents/wsh4dvm6x81k</guid>
        </item>
        <item>
          <title>Incident with GitHub Packages</title>
          <description>
    &lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;03:18&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;02:26&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Packages.&lt;/p&gt;      </description>
          <pubDate>Fri, 27 Aug 2021 03:18:56 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/1n14tdm7mbpf</link>
          <guid>https://www.githubstatus.com/incidents/1n14tdm7mbpf</guid>
        </item>
        <item>
          <title>Incident with GitHub Pages</title>
          <description>
    &lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;25&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;19:20&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;25&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;19:02&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - We&apos;re currently investigating issues creating HTTPS certificates for GitHub Pages with custom domains.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;25&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;18:38&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Pages.&lt;/p&gt;      </description>
          <pubDate>Wed, 25 Aug 2021 19:20:51 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/4my29vphhm7m</link>
          <guid>https://www.githubstatus.com/incidents/4my29vphhm7m</guid>
        </item>
        <item>
          <title>Incident with Codespaces</title>
          <description>
    &lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;23&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;15:04&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;23&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;14:39&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Codespaces.&lt;/p&gt;      </description>
          <pubDate>Mon, 23 Aug 2021 15:04:20 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/gxq7362skqxs</link>
          <guid>https://www.githubstatus.com/incidents/gxq7362skqxs</guid>
        </item>
        <item>
          <title>Sunsetting API Authentication via Query Parameters, and the OAuth Applications API</title>
          <description>
    &lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;13&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;14:00&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Completed&lt;/strong&gt; - The scheduled maintenance has been completed.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;11&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;14:00&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;In progress&lt;/strong&gt; - Scheduled maintenance is currently in progress. We will provide updates as necessary.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jun &lt;var data-var=&apos;date&apos;&gt;29&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;07:14&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Scheduled&lt;/strong&gt; - We will be removing &lt;a href=&quot;https://developer.github.com/changes/2020-02-10-deprecating-auth-through-query-param/&quot;&gt;API Authentication via Query Parameters&lt;/a&gt; and &lt;a href=&quot;https://developer.github.com/changes/2020-02-14-deprecating-oauth-app-endpoint&quot;&gt;OAuth Application API&lt;/a&gt; during these hours as part of a planned deprecation cycle. For more information, please read our &lt;a href=&quot;https://github.blog/changelog/2021-04-19-sunsetting-api-authentication-via-query-parameters-and-the-oauth-applications-api/&quot;&gt;blog post&lt;/a&gt;.&lt;/p&gt;      </description>
          <pubDate>Fri, 13 Aug 2021 14:00:29 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/6gpzw3mdnkwj</link>
          <guid>https://www.githubstatus.com/incidents/6gpzw3mdnkwj</guid>
        </item>
        <item>
          <title>Incident with Codespaces</title>
          <description>
    &lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;12&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;08:45&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;12&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;06:40&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Codespaces.&lt;/p&gt;      </description>
          <pubDate>Thu, 12 Aug 2021 08:45:21 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/rgsjxcsm94vh</link>
          <guid>https://www.githubstatus.com/incidents/rgsjxcsm94vh</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions</title>
          <description>
    &lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;23:10&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;22:37&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Monitoring&lt;/strong&gt; - A fix has been rolled out and we are monitoring recovery. Jobs are starting to run and logs/artifacts are loading now.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;22:24&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Identified&lt;/strong&gt; - We hit an issue with the main request routing service which is causing errors with running jobs, and retrieving logs/artifacts. The team has identified the cause and is actively mitigating.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;20:16&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Actions is now experiencing degraded availability. We are continuing to investigate.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;20:09&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Actions.&lt;/p&gt;      </description>
          <pubDate>Tue, 10 Aug 2021 23:10:51 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/lc8s9rtyjmgq</link>
          <guid>https://www.githubstatus.com/incidents/lc8s9rtyjmgq</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions, API Requests, Git Operations, Issues, Microsoft Teams Integration, GitHub Packages, GitHub Pages, Pull Requests, Slack Integration, and Webhooks</title>
          <description>
    &lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;16:57&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;16:56&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Actions is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;16:50&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Issues is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;16:49&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Pull Requests is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;16:48&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Packages is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;16:42&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - API Requests is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;16:38&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Git Operations is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;16:33&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Pages is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;16:02&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Microsoft Teams Integration is experiencing degraded performance. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;16:01&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Slack Integration is experiencing degraded performance. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;15:40&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Git Operations is experiencing degraded performance. We are continuing to investigate.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;15:38&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Packages is experiencing degraded performance. We are continuing to investigate.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;15:35&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - API Requests is experiencing degraded performance. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;15:33&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Issues is experiencing degraded performance. We are continuing to investigate.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;15:32&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Pages is experiencing degraded performance. We are continuing to investigate.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;15:32&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Pull Requests is experiencing degraded performance. We are continuing to investigate.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;15:32&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Actions is experiencing degraded performance. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;15:16&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Webhooks.&lt;/p&gt;      </description>
          <pubDate>Tue, 10 Aug 2021 16:57:32 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/rmfrw9dfbtbp</link>
          <guid>https://www.githubstatus.com/incidents/rmfrw9dfbtbp</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions</title>
          <description>
    &lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt; 6&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;16:05&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt; 6&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;15:31&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Actions.&lt;/p&gt;      </description>
          <pubDate>Fri, 06 Aug 2021 16:05:18 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/k0nyx2m985dl</link>
          <guid>https://www.githubstatus.com/incidents/k0nyx2m985dl</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions</title>
          <description>
    &lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt; 5&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;17:43&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Aug &lt;var data-var=&apos;date&apos;&gt; 5&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;14:09&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Actions.&lt;/p&gt;      </description>
          <pubDate>Thu, 05 Aug 2021 17:43:27 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/7p1nnvkgh96y</link>
          <guid>https://www.githubstatus.com/incidents/7p1nnvkgh96y</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions and Webhooks</title>
          <description>
    &lt;p&gt;&lt;small&gt;Jul &lt;var data-var=&apos;date&apos;&gt;29&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;21:18&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jul &lt;var data-var=&apos;date&apos;&gt;29&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;21:08&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Webhooks is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jul &lt;var data-var=&apos;date&apos;&gt;29&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;20:45&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Actions is experiencing degraded performance. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jul &lt;var data-var=&apos;date&apos;&gt;29&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;20:29&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Webhooks.&lt;/p&gt;      </description>
          <pubDate>Thu, 29 Jul 2021 21:18:14 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/8qy34dmg4kdm</link>
          <guid>https://www.githubstatus.com/incidents/8qy34dmg4kdm</guid>
        </item>
        <item>
          <title>Incident with Webhooks</title>
          <description>
    &lt;p&gt;&lt;small&gt;Jul &lt;var data-var=&apos;date&apos;&gt; 1&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;11:35&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jul &lt;var data-var=&apos;date&apos;&gt; 1&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;10:19&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Webhooks.&lt;/p&gt;      </description>
          <pubDate>Thu, 01 Jul 2021 11:35:47 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/z29rz4vyy3d3</link>
          <guid>https://www.githubstatus.com/incidents/z29rz4vyy3d3</guid>
        </item>
      </channel>
    </rss>
    """
  end
end
