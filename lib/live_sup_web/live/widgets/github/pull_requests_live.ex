defmodule LiveSupWeb.Live.Widgets.Github.PullRequestsLive do
  use LiveSupWeb.Live.Widgets.WidgetLive
  alias LiveSupWeb.Widgets.Github.GithubHelper

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
      <.live_component
        module={WidgetHeaderComponent}
        id={"#{widget_data.id}-header"}
        widget_data={widget_data}
        icon_svg={GithubHelper.icon(widget_data.public_settings["state"])}
      />
      <!-- Widget Content -->
      <div class="items-center p-2 bg-white rounded-md dark:bg-darker min-h-[132px]">
        <%= if Enum.any?(widget_data.data) do %>
          <div class="flex-auto divide-y divide-gray-100 dark:divide-dark p-1">
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
        <% else %>
          <svg
            class="h-20 w-20 m-auto"
            viewBox="0 0 81 80"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              d="M66.5 34.6667C66.8333 36.3334 67.1667 38.3334 67.1667 40.0001C67.1667 54.6668 55.1667 66.6668 40.5 66.6668C25.8333 66.6668 13.8333 54.6668 13.8333 40.0001C13.8333 25.3334 25.8333 13.3334 40.5 13.3334C45.8333 13.3334 51.1667 15.0001 55.1667 17.6667L59.8333 13.0001C54.5 9.00008 47.8333 6.66675 40.5 6.66675C22.1667 6.66675 7.16666 21.6667 7.16666 40.0001C7.16666 58.3334 22.1667 73.3334 40.5 73.3334C58.8333 73.3334 73.8333 58.3334 73.8333 40.0001C73.8333 36.3334 73.1667 32.6667 72.1667 29.3334L66.5 34.6667Z"
              fill="#21D3EE"
            />
            <path
              d="M37.1667 54.6667L21.5 39L26.1667 34.3333L37.1667 45.3333L71.5 11L76.1667 15.6667L37.1667 54.6667Z"
              fill="#21D3EE"
            />
            <path
              opacity="0.3"
              d="M40.5 6.66675C31.6594 6.66675 23.181 10.1786 16.9298 16.4299C10.6786 22.6811 7.16666 31.1595 7.16666 40.0001C7.16666 48.8406 10.6786 57.3191 16.9298 63.5703C23.181 69.8215 31.6594 73.3334 40.5 73.3334C49.3405 73.3334 57.819 69.8215 64.0702 63.5703C70.3214 57.3191 73.8333 48.8406 73.8333 40.0001C73.8333 31.1595 70.3214 22.6811 64.0702 16.4299C57.819 10.1786 49.3405 6.66675 40.5 6.66675Z"
              fill="#21D3EE"
            />
          </svg>
          <p class="text-center m-2 text-sm ">
            No <strong><%= widget_data.public_settings["state"] %></strong> pull requests to display
          </p>
        <% end %>
      </div>
      <.live_component
        module={WidgetFooterComponent}
        id={"#{widget_data.id}-footer"}
        widget_data={widget_data}
      />
      <!-- /Github Pull Requests -->
    </.live_component>
    """
  end
end
