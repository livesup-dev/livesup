defmodule LiveSupWeb.Live.Widgets.Github.PullRequestsLive do
  use LiveSupWeb.Live.Widgets.WidgetLive
  alias LiveSupWeb.Widgets.Github.GithubHelper

  @impl true
  def render_widget(assigns) do
    ~H"""
    <.live_component module={SmartRenderComponent} id={@widget_data.id} let={widget_data} widget_data={@widget_data}>
      <!-- Github Pull Requests -->
        <.live_component module={WidgetHeaderComponent} id={"#{widget_data.id}-header"} widget_data={widget_data} icon_svg={GithubHelper.icon(widget_data.public_settings["state"])}/>
        <div class="flex-auto divide-y divide-gray-100 dark:divide-dark p-1">
          <%= for {pull_request, counter} <- Enum.with_index(widget_data.data) do %>
            <div class="flex p-2">
              <div class={"flex h-auto w-2 #{GithubHelper.pull_request_color(pull_request[:created_at], widget_data.public_settings["state"])}"}></div>
              <div class="flex-auto pl-2">
                <p class="text-blue-500 hover:underline text-base"><a href={pull_request[:html_url]} target="blank"><%= pull_request[:short_title] %></a></p>
                <p class="font-mono text-xs">#<%= pull_request[:number] %> <%=GithubHelper.state_to_label(widget_data.public_settings["state"])%> <%= pull_request[:created_at_ago] %> by <%= pull_request[:user][:login] %></p>
              </div>
            </div>
          <% end %>
        </div>
        <.live_component module={WidgetFooterComponent} id={"#{widget_data.id}-footer"} widget_data={widget_data} />
      <!-- /Github Pull Requests -->
    </.live_component>
    """
  end
end
