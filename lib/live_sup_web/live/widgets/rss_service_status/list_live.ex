defmodule LiveSupWeb.Live.Widgets.RssServiceStatus.ListLive do
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
      <.live_component
        module={WidgetHeaderComponent}
        id={"#{widget_data.id}-header"}
        widget_data={widget_data}
      />
      <div class="flex-auto divide-y divide-gray-100 dark:divide-gray-500 p-2">
        <%= for {entry, _counter} <- Enum.with_index(widget_data.data) do %>
          <div class="flex pt-2 pb-2">
            <p class="basis-1/6 pt-1">
              <img
                src={entry[:icon]}
                class="rounded-full bg-slate-100 w-8 ring-1 ring-slate-200 dark:ring-white dark:bg-transparent"
              />
            </p>

            <%= if entry[:status] == :incident do %>
              <p class="basis-3/4">
                <a href={entry[:url]} target="blank" class="hover:underline"><%= entry[:title] %></a>
              </p>
              <p class="basis-1/6 pt-1">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-7 w-7 m-auto"
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
              </p>
            <% else %>
              <p class="basis-3/4">
                <a target="_blank" href={entry[:url]} target="blank" class="hover:underline">
                  <%= entry[:service_name] %>
                </a>
                <br />
                <a target="_blank" href={entry[:url]}>
                  <span class="text-blue-500 text-sm text-stone-400">
                    Last incident: <%= entry[:created_at_ago] %>
                  </span>
                </a>
              </p>
              <p class="basis-1/6 pt-1">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-7 w-7 m-auto"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="#21D3EE"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
              </p>
            <% end %>
          </div>
        <% end %>
      </div>
      <.live_component
        module={WidgetFooterComponent}
        id={"#{widget_data.id}-footer"}
        widget_data={widget_data}
      />
    </.live_component>
    """
  end
end
