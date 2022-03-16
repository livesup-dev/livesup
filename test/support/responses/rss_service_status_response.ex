defmodule LiveSup.Test.Support.Responses.RssServiceStatusResponse do
  def get() do
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
      <channel>
        <title>GitHub Status - Incident History</title>
        <link>https://www.githubstatus.com</link>
        <description>Statuspage</description>
        <pubDate>Wed, 16 Mar 2022 19:46:08 +0000</pubDate>
        <item>
          <title>Incident with GitHub Actions, Codespaces, Issues, and Webhooks</title>
          <description>
    &lt;p&gt;&lt;small&gt;Mar &lt;var data-var=&apos;date&apos;&gt;16&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;19:46&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Mar &lt;var data-var=&apos;date&apos;&gt;16&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;18:57&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Webhooks is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Mar &lt;var data-var=&apos;date&apos;&gt;16&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;18:37&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Issues is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Mar &lt;var data-var=&apos;date&apos;&gt;16&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;18:30&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Codespaces is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Mar &lt;var data-var=&apos;date&apos;&gt;16&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;16:06&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Codespaces is experiencing degraded performance. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Mar &lt;var data-var=&apos;date&apos;&gt;16&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;14:29&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Actions is experiencing degraded performance. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Mar &lt;var data-var=&apos;date&apos;&gt;16&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;14:10&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Webhooks is experiencing degraded performance. We are continuing to investigate.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Mar &lt;var data-var=&apos;date&apos;&gt;16&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;14:09&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Issues.&lt;/p&gt;      </description>
          <pubDate>Wed, 16 Mar 2022 19:46:00 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/fpk08rxnqjz2</link>
          <guid>https://www.githubstatus.com/incidents/fpk08rxnqjz2</guid>
        </item>
        <item>
          <title>Incident with Slack Integration</title>
          <description>
    &lt;p&gt;&lt;small&gt;Mar &lt;var data-var=&apos;date&apos;&gt; 9&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;17:45&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Mar &lt;var data-var=&apos;date&apos;&gt; 9&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;11:57&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Slack Integration is experiencing degraded performance. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Mar &lt;var data-var=&apos;date&apos;&gt; 9&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;11:24&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded availability for Slack Integration.&lt;/p&gt;      </description>
          <pubDate>Wed, 09 Mar 2022 17:45:38 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/xdzs70gjthls</link>
          <guid>https://www.githubstatus.com/incidents/xdzs70gjthls</guid>
        </item>
        <item>
          <title>Incident with Pull Requests</title>
          <description>
    &lt;p&gt;&lt;small&gt;Mar &lt;var data-var=&apos;date&apos;&gt; 4&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;16:37&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Mar &lt;var data-var=&apos;date&apos;&gt; 4&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;15:30&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Pull Requests.&lt;/p&gt;      </description>
          <pubDate>Fri, 04 Mar 2022 16:37:48 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/416ft5p3mr89</link>
          <guid>https://www.githubstatus.com/incidents/416ft5p3mr89</guid>
        </item>
        <item>
          <title>Incident with Codespaces</title>
          <description>
    &lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt;17&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;02:30&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt;17&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;00:53&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Codespaces.&lt;/p&gt;      </description>
          <pubDate>Thu, 17 Feb 2022 02:30:09 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/r62rpxrk3ytj</link>
          <guid>https://www.githubstatus.com/incidents/r62rpxrk3ytj</guid>
        </item>
        <item>
          <title>Incident with Codespaces</title>
          <description>
    &lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt;16&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;05:12&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt;16&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;01:54&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Codespaces.&lt;/p&gt;      </description>
          <pubDate>Wed, 16 Feb 2022 05:12:14 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/3pwsvtkmmp3k</link>
          <guid>https://www.githubstatus.com/incidents/3pwsvtkmmp3k</guid>
        </item>
        <item>
          <title>Incident with Codespaces</title>
          <description>
    &lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt;10&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;00:35&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 9&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;22:49&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Codespaces.&lt;/p&gt;      </description>
          <pubDate>Thu, 10 Feb 2022 00:35:40 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/1b73r6x5wkdx</link>
          <guid>https://www.githubstatus.com/incidents/1b73r6x5wkdx</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions, GitHub Pages, and Webhooks</title>
          <description>
    &lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 6&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;02:01&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 6&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;01:41&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Webhooks is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 6&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;01:33&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Pages is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 5&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;23:38&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Pages is experiencing degraded performance. We are continuing to investigate.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 5&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;22:25&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Actions is experiencing degraded performance. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 5&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;22:18&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Webhooks.&lt;/p&gt;      </description>
          <pubDate>Sun, 06 Feb 2022 02:01:26 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/vvthhf8gxt80</link>
          <guid>https://www.githubstatus.com/incidents/vvthhf8gxt80</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions</title>
          <description>
    &lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 3&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;13:42&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 3&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;13:32&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Actions.&lt;/p&gt;      </description>
          <pubDate>Thu, 03 Feb 2022 13:42:12 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/bgh89d5s08yc</link>
          <guid>https://www.githubstatus.com/incidents/bgh89d5s08yc</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions, Codespaces, Issues, and Pull Requests</title>
          <description>
    &lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 2&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;19:34&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 2&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;19:34&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Pull Requests is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 2&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;19:33&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Codespaces is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 2&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;19:32&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Actions is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 2&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;19:26&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Issues and Pull Requests are now experiencing degraded performance. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 2&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;19:19&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Codespaces is experiencing degraded performance. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 2&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;19:17&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Actions is now experiencing degraded performance. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 2&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;19:14&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Actions, Issues, and Pull Requests are now experiencing degraded availability. We are continuing to investigate.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Feb &lt;var data-var=&apos;date&apos;&gt; 2&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;19:12&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Actions, Issues, and Pull Requests.&lt;/p&gt;      </description>
          <pubDate>Wed, 02 Feb 2022 19:34:33 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/fz1bdbw24y81</link>
          <guid>https://www.githubstatus.com/incidents/fz1bdbw24y81</guid>
        </item>
        <item>
          <title>Incident with Git Operations and GitHub Packages</title>
          <description>
    &lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;29&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;21:09&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;29&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;21:09&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Git Operations is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;29&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;19:22&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Packages is experiencing degraded performance. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;29&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;19:16&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Git Operations.&lt;/p&gt;      </description>
          <pubDate>Sat, 29 Jan 2022 21:09:26 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/95cmptpwp8p3</link>
          <guid>https://www.githubstatus.com/incidents/95cmptpwp8p3</guid>
        </item>
        <item>
          <title>Incident with GitHub Packages</title>
          <description>
    &lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;28&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;09:30&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;28&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;07:30&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Packages.&lt;/p&gt;      </description>
          <pubDate>Fri, 28 Jan 2022 09:30:34 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/67lqr3ds3dph</link>
          <guid>https://www.githubstatus.com/incidents/67lqr3ds3dph</guid>
        </item>
        <item>
          <title>Errors on the GitHub Dashboard</title>
          <description>
    &lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;28&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;02:10&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;28&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;01:57&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Monitoring&lt;/strong&gt; - We have deployed a potential fix and are monitoring resolution.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;28&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;01:08&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - While the dashboard page is currently down, the majority of the functionality on GitHub is still accessible (e.g Repos, Pull Requests, Issues, etc), we are continuing to work on resolving this issue&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;28&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;00:50&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating errors on the GitHub dashboard.&lt;/p&gt;      </description>
          <pubDate>Fri, 28 Jan 2022 02:10:07 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/xvk42jkm6fzk</link>
          <guid>https://www.githubstatus.com/incidents/xvk42jkm6fzk</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions, Issues, GitHub Packages, and Pull Requests</title>
          <description>
    &lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;15:34&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;15:33&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Actions, Issues, and Pull Requests are operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;13:25&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Packages is experiencing degraded performance. We are continuing to investigate.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;13:18&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Actions, Issues, and Pull Requests.&lt;/p&gt;      </description>
          <pubDate>Thu, 27 Jan 2022 15:34:45 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/29xnrws671f0</link>
          <guid>https://www.githubstatus.com/incidents/29xnrws671f0</guid>
        </item>
        <item>
          <title>Incident with Codespaces</title>
          <description>
    &lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;14&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;05:29&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;14&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;00:09&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Codespaces.&lt;/p&gt;      </description>
          <pubDate>Fri, 14 Jan 2022 05:29:57 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/6s1qq264rn0t</link>
          <guid>https://www.githubstatus.com/incidents/6s1qq264rn0t</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions and GitHub Pages</title>
          <description>
    &lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;12&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;03:16&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;12&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;03:15&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Pages is operating normally.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;12&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;02:28&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Actions is experiencing degraded performance. We are continuing to investigate.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt;12&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;02:22&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Pages.&lt;/p&gt;      </description>
          <pubDate>Wed, 12 Jan 2022 03:16:41 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/cypv026dr23w</link>
          <guid>https://www.githubstatus.com/incidents/cypv026dr23w</guid>
        </item>
        <item>
          <title>Incident with GitHub Pages</title>
          <description>
    &lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt; 5&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;19:37&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Jan &lt;var data-var=&apos;date&apos;&gt; 5&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;19:16&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Pages.&lt;/p&gt;      </description>
          <pubDate>Wed, 05 Jan 2022 19:37:32 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/vjq8l5y6kqbj</link>
          <guid>https://www.githubstatus.com/incidents/vjq8l5y6kqbj</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions</title>
          <description>
    &lt;p&gt;&lt;small&gt;Dec &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;16:50&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Dec &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;13:20&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Actions.&lt;/p&gt;      </description>
          <pubDate>Mon, 27 Dec 2021 16:50:03 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/gh0vvxtlj5v7</link>
          <guid>https://www.githubstatus.com/incidents/gh0vvxtlj5v7</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions</title>
          <description>
    &lt;p&gt;&lt;small&gt;Dec &lt;var data-var=&apos;date&apos;&gt;18&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;04:17&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Dec &lt;var data-var=&apos;date&apos;&gt;18&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;03:53&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Actions.&lt;/p&gt;      </description>
          <pubDate>Sat, 18 Dec 2021 04:17:57 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/drp1bpq50ymr</link>
          <guid>https://www.githubstatus.com/incidents/drp1bpq50ymr</guid>
        </item>
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
        <item>
          <title>Incident with GitHub Docs</title>
          <description>
    &lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;29&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;13:28&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;29&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;12:30&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded availability for GitHub Docs.&lt;/p&gt;      </description>
          <pubDate>Mon, 29 Nov 2021 13:28:24 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/22y5yl6gcc6b</link>
          <guid>https://www.githubstatus.com/incidents/22y5yl6gcc6b</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions, API Requests, Codespaces, Git Operations, Issues, GitHub Packages, GitHub Pages, Pull Requests, and Webhooks</title>
          <description>
    &lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;23:30&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;23:15&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Actions, API Requests, Codespaces, Git Operations, Issues, GitHub Packages, and Pull Requests are now experiencing degraded performance. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;22:59&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - We identified the cause of the problem and are working on remediation.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;21:42&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Codespaces is experiencing degraded availability. We are continuing to investigate.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;21:09&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Webhooks is experiencing degraded performance. We are continuing to investigate.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;20:56&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Pages is experiencing degraded performance. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;20:55&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - We&apos;re investigating errors affecting most GitHub services. We&apos;re actively investigating and will provide an update as soon as possible.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;20:50&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - API Requests is experiencing degraded availability. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;20:49&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - Git Operations is experiencing degraded availability. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;20:48&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Packages is experiencing degraded availability. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;20:47&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Update&lt;/strong&gt; - GitHub Actions, Issues, and Pull Requests are experiencing degraded availability. We are still investigating and will provide an update when we have one.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;27&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;20:43&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Actions.&lt;/p&gt;      </description>
          <pubDate>Sat, 27 Nov 2021 23:30:53 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/r5qrpp2f5fc0</link>
          <guid>https://www.githubstatus.com/incidents/r5qrpp2f5fc0</guid>
        </item>
        <item>
          <title>Incident with Issues and Pull Requests</title>
          <description>
    &lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;22&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;13:40&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;22&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;13:36&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Issues and Pull Requests.&lt;/p&gt;      </description>
          <pubDate>Mon, 22 Nov 2021 13:40:55 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/98jx6ncp3s4z</link>
          <guid>https://www.githubstatus.com/incidents/98jx6ncp3s4z</guid>
        </item>
        <item>
          <title>Incident with Codespaces</title>
          <description>
    &lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;13&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;00:57&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt;12&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;23:57&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for Codespaces.&lt;/p&gt;      </description>
          <pubDate>Sat, 13 Nov 2021 00:57:10 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/02gsdsw3twdc</link>
          <guid>https://www.githubstatus.com/incidents/02gsdsw3twdc</guid>
        </item>
        <item>
          <title>Incident with GitHub Actions</title>
          <description>
    &lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt; 4&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;18:54&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Resolved&lt;/strong&gt; - This incident has been resolved.&lt;/p&gt;&lt;p&gt;&lt;small&gt;Nov &lt;var data-var=&apos;date&apos;&gt; 4&lt;/var&gt;, &lt;var data-var=&apos;time&apos;&gt;18:13&lt;/var&gt; UTC&lt;/small&gt;&lt;br&gt;&lt;strong&gt;Investigating&lt;/strong&gt; - We are investigating reports of degraded performance for GitHub Actions.&lt;/p&gt;      </description>
          <pubDate>Thu, 04 Nov 2021 18:54:15 +0000</pubDate>
          <link>https://www.githubstatus.com/incidents/4cnqjxrv0vzg</link>
          <guid>https://www.githubstatus.com/incidents/4cnqjxrv0vzg</guid>
        </item>
      </channel>
    </rss>
    """
  end
end
