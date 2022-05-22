defmodule LiveSup.Test.Core.Datasources.DataHelper.JiraListOfUsers do
  def get() do
    """
    [
      {
          "self": "https://livesup.atlassian.net/rest/api/3/user?accountId=5a390ef9280a8d389404e33a",
          "accountId": "5a390ef9280a8d389404e33a",
          "accountType": "atlassian",
          "emailAddress": "emiliano@livesup.com",
          "avatarUrls": {
              "48x48": "https://avatar.public.atl-paas.net/5a390ef9280a8d389404e33a/53550071-f045-44f3-bc75-96956f8541c3/48",
              "24x24": "https://avatar.public.atl-paas.net/5a390ef9280a8d389404e33a/53550071-f045-44f3-bc75-96956f8541c3/24",
              "16x16": "https://avatar.public.atl-paas.net/5a390ef9280a8d389404e33a/53550071-f045-44f3-bc75-96956f8541c3/16",
              "32x32": "https://avatar.public.atl-paas.net/5a390ef9280a8d389404e33a/53550071-f045-44f3-bc75-96956f8541c3/32"
          },
          "displayName": "Emiliano Jankowski",
          "active": true,
          "timeZone": "America/New_York",
          "locale": "en_US"
      }
    ]
    """
  end
end
