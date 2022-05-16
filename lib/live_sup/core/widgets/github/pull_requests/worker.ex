defmodule LiveSup.Core.Widgets.Github.PullRequests.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Github.PullRequests.Handler

  @default_title "{owner}/{repository}"

  @impl true
  def settings_keys, do: ["owner", "repository", "token", "state", "limit"]

  @impl true
  def public_settings, do: ["owner", "repository", "state"]

  @impl true
  def build_data(settings, _context) do
    settings
    |> Handler.get_data()
  end

  @impl true
  def default_title() do
    @default_title
  end
end
