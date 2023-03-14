defmodule LiveSupWeb.Live.Widgets.PagerDuty.OnCallLive do
  use LiveSupWeb.Live.Widgets.WidgetLive

  @impl true
  def render_widget(assigns) do
    ~H"""
    <.live_component
      :let={widget_data}
      module={SmartRenderComponent}
      id={@widget_data.id}
      widget_data={@widget_data}
    >
      <!-- Metrics Goal -->
      <.live_component
        module={WidgetHeaderComponent}
        id={"#{widget_data.id}-header"}
        widget_data={widget_data}
      />
      <!-- Widget Content -->
      <div class="ls-widget-body-default">
        <%= for {on_calls, key} <-  Enum.with_index(widget_data.data) do %>
          <div class="card p-3">
            <div class="flex items-center justify-between space-x-2">
              <div class="flex items-center space-x-3">
                <div class="avatar h-11 w-11">
                  <img
                    class={
                      if key == 0,
                        do: "w-11 h-11 p-1 rounded-full",
                        else: "w-11 h-11 p-1 rounded-full"
                    }
                    src={on_calls.user[:avatar_url]}
                    alt=""
                  />
                  <div class={
                    if key == 0,
                      do:
                        "absolute right-0 h-3 w-3 rounded-full border-2 border-white dark:border-navy-700 bg-green-500",
                      else:
                        "absolute right-0 h-3 w-3 rounded-full border-2 border-white dark:border-navy-700 bg-yellow-500"
                  }>
                  </div>
                </div>
              </div>
              <div>
                <p class="break-words font-medium text-slate-700 line-clamp-1 dark:text-navy-100">
                  <%= on_calls.user[:name] %>
                </p>
                <p class="mt-0.5 text-xs text-slate-400 line-clamp-1 dark:text-navy-300">
                  From: <%= format_date(on_calls[:start]) %>, to: <%= format_date(on_calls[:end]) %>
                </p>
              </div>
              <div class="mt-0.5 text-xs text-slate-400 line-clamp-1 dark:text-navy-300">
                <!--  add [dark] class for bright background -->
                <span class="bg-dark text-xs font-medium inline-flex items-center px-2.5 py-0.5 rounded dark:bg-dark">
                  <svg
                    class="mr-1 w-3 h-3"
                    fill="currentColor"
                    viewBox="0 0 20 20"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z"
                      clip-rule="evenodd"
                    >
                    </path>
                  </svg>
                  <%= if on_calls[:days_left] == 0 do %>
                    Starts Today
                  <% else %>
                    In <%= on_calls[:days_left] %> days
                  <% end %>
                </span>
              </div>
            </div>
          </div>
        <% end %>
      </div>
      <!-- /Widget Content -->
      <!-- /Metrics Goal -->
      <.live_component
        module={WidgetFooterComponent}
        id={"#{widget_data.id}-footer"}
        widget_data={widget_data}
      />
    </.live_component>
    """
  end

  def format_date(date) do
    LiveSup.Helpers.DateHelper.date_without_year(date)
  end
end
