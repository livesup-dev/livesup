defmodule LiveSupWeb.Live.Widgets.Github.PullRequestsLive do
  use LiveSupWeb.Live.Widgets.WidgetLive
  alias LiveSupWeb.Widgets.Github.GithubHelper
  alias LiveSup.Schemas.WidgetInstance

  @impl true
  def render_widget(assigns) do
    icon_svg =
      assigns.widget_instance
      |> WidgetInstance.get_setting("state")
      |> find_icon()

    widget_data = Map.merge(assigns.widget_data, %{icon_svg: icon_svg})

    assigns = assigns |> assign(:widget_data, widget_data)

    ~H"""
    <.live_component module={SmartRenderComponent} id={@widget_data.id} let={widget_data} widget_data={@widget_data}>
      <!-- Github Pull Requests -->
        <.live_component module={WidgetHeaderComponent} id={"#{widget_data.id}-header"} widget_data={widget_data}/>
        <div class="flex-auto divide-y divide-gray-100 dark:divide-dark p-1">
          <%= for {pull_request, counter} <- Enum.with_index(widget_data.data) do %>
            <div class="flex p-2">
              <div class={"flex h-auto w-2 #{GithubHelper.pull_request_color(pull_request[:created_at])}"}></div>
              <div class="flex-auto pl-2">
                <p class="text-blue-500 hover:underline text-base"><a href={pull_request[:html_url]} target="blank"><%= pull_request[:short_title] %></a></p>
                <p class="font-mono text-xs">#<%= pull_request[:number] %> opened <%= pull_request[:created_at_ago] %> by <%= pull_request[:user][:login] %></p>
              </div>
            </div>
          <% end %>
        </div>
        <.live_component module={WidgetFooterComponent} id={"#{widget_data.id}-footer"} widget_data={widget_data} />
      <!-- /Github Pull Requests -->
    </.live_component>
    """
  end

  defp find_icon("open") do
    """
    <svg stroke="green" class="w-4" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M7.177 3.073L9.573.677A.25.25 0 0110 .854v4.792a.25.25 0 01-.427.177L7.177 3.427a.25.25 0 010-.354zM3.75 2.5a.75.75 0 100 1.5.75.75 0 000-1.5zm-2.25.75a2.25 2.25 0 113 2.122v5.256a2.251 2.251 0 11-1.5 0V5.372A2.25 2.25 0 011.5 3.25zM11 2.5h-1V4h1a1 1 0 011 1v5.628a2.251 2.251 0 101.5 0V5A2.5 2.5 0 0011 2.5zm1 10.25a.75.75 0 111.5 0 .75.75 0 01-1.5 0zM3.75 12a.75.75 0 100 1.5.75.75 0 000-1.5z"></path></svg>
    """
  end

  defp find_icon("closed") do
    """
    <svg stroke="#a371f7" class="w-4" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M5 3.254V3.25v.005a.75.75 0 110-.005v.004zm.45 1.9a2.25 2.25 0 10-1.95.218v5.256a2.25 2.25 0 101.5 0V7.123A5.735 5.735 0 009.25 9h1.378a2.251 2.251 0 100-1.5H9.25a4.25 4.25 0 01-3.8-2.346zM12.75 9a.75.75 0 100-1.5.75.75 0 000 1.5zm-8.5 4.5a.75.75 0 100-1.5.75.75 0 000 1.5z"></path></svg>
    """
  end
end
