defmodule LiveSupWeb.Live.Widgets.RssServiceStatus.SingleLive do
  use LiveSupWeb.Live.Widgets.WidgetLive

  @impl true
  def render_widget(assigns) do
    ~H"""
    <.live_component
      :let={widget_data}
      module={SmartRenderComponent}
      id="core-health-status"
      widget_data={@widget_data}
    >
      <!-- RSS Service -->
      <.live_component
        module={WidgetHeaderComponent}
        id={"#{widget_data.id}-header"}
        widget_data={widget_data}
      />
      <!-- Widget Content -->
      <div class="p-2">
        <%= if widget_data.data.status == :incident do %>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-20 w-20 m-auto"
            fill="none"
            viewBox="0 0 24 24"
            stroke="#F96C6C"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"
            />
          </svg>
          <p class="text-center mt-2">
            <a href={widget_data.data.url} target="blank" class="hover:underline">
              <%= widget_data.data.title %>
            </a>
          </p>
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
          <p class="text-center mt-2">
            <a
              target="_blank"
              href={widget_data.data.url}
              class="text-blue-500 hover:underline text-stone-400"
            >
              Last incident: <%= widget_data.data.created_at_ago %>
            </a>
          </p>
        <% end %>
      </div>
      <!-- /Widget Content -->
      <!-- /RSS Service -->
      <.live_component
        module={WidgetFooterComponent}
        id={"#{widget_data.id}-footer"}
        widget_data={widget_data}
      />
    </.live_component>
    """
  end
end
