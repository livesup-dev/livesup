defmodule LiveSupWeb.Live.Widgets.Github.PullRequestsLive do
  use LiveSupWeb.Live.Widgets.WidgetLive
  alias LiveSupWeb.Widgets.Github.GithubHelper
  alias LiveSupWeb.Live.Components.{WidgetHeaderComponent, WidgetFooterComponent}
  import LiveSupWeb.Components.IconsComponent

  @impl true
  def render_widget(assigns) do
    ~H"""
    <.live_component
      :let={widget_data}
      module={SmartRenderComponent}
      id={@widget_data.id}
      widget_data={@widget_data}
    >
      <!-- Github Pull Requests -->
      <WidgetHeaderComponent.render
        widget_data={widget_data}
        icon_svg={GithubHelper.icon(widget_data.public_settings["state"])}
      />
      <!-- Widget Content -->
      <div class="items-center p-2 bg-white rounded-md dark:bg-darker min-h-[132px]">
        <div
          :if={Enum.any?(widget_data.data)}
          class="flex-auto divide-y divide-gray-100 dark:divide-dark p-1"
        >
          <%= for {pull_request, _counter} <- Enum.with_index(widget_data.data) do %>
            <div class="flex p-2">
              <div class={"flex h-auto w-2 #{GithubHelper.pull_request_color(pull_request[:created_at], widget_data.public_settings["state"])}"}>
              </div>
              <div class="flex-auto pl-2">
                <p class="text-blue-500 hover:underline text-base">
                  <a href={pull_request[:html_url]} target="blank">
                    <%= pull_request[:short_title] %>
                  </a>
                </p>
                <p class="font-mono text-xs">
                  #<%= pull_request[:number] %> <%= GithubHelper.state_to_label(
                    widget_data.public_settings["state"]
                  ) %> <%= pull_request[:created_at_ago] %> by <%= pull_request[:user][:login] %>
                </p>
              </div>
            </div>
          <% end %>
        </div>
        <.empty_data_icon
          :if={Enum.empty?(widget_data.data)}
          svg_class="h-20 w-20"
          description={"No '#{widget_data.public_settings["state"]}' pull requests to display."}
        />
      </div>
      <WidgetFooterComponent.render widget_data={widget_data} />
      <!-- /Github Pull Requests -->
    </.live_component>
    """
  end
end
