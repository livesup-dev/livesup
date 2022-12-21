defmodule LiveSupWeb.Live.Widgets.PagerDuty.OnCallLive do
  use LiveSupWeb.Live.Widgets.WidgetLive

  @impl true
  def render_widget(assigns) do
    ~H"""
    <.live_component
      module={SmartRenderComponent}
      id={@widget_data.id}
      :let={widget_data}
      widget_data={@widget_data}
    >
      <!-- Metrics Goal -->
      <.live_component
        module={WidgetHeaderComponent}
        id={"#{widget_data.id}-header"}
        widget_data={widget_data}
      />
      <!-- Widget Content -->
      <div class="p-2 grid justify-items-center min-h-[132px] divide-y">
        <%= for {on_calls, key} <-  Enum.with_index(widget_data.data) do %>
          <div class="card w-full hover:shadow-none relative flex flex-col mx-auto">
            <div class="profile w-full flex my-3 text-black dark:text-white">
              <img
                class={
                  if key == 0,
                    do: "w-12 h-12 p-1 rounded-full bg-green-500",
                    else: "w-12 h-12 p-1 rounded-full bg-yellow-100"
                }
                src={on_calls.user[:avatar_url]}
                alt=""
              />
              <div class="title ml-3 font-bold flex flex-col">
                <div class="name break-words"><%= on_calls.user[:name] %></div>
                <!--  add [dark] class for bright background -->
                <div class="add font-semibold text-sm italic dark">
                  From: <%= format_date(on_calls[:start]) %>, to: <%= format_date(on_calls[:end]) %>
                </div>
              </div>
              <%= if key == 1 && on_calls[:days_left] <= 3 do %>
                <div class="text-sm ml-10 flex flex-col animate-pulse">
                  <!--  add [dark] class for bright background -->
                  <span class="bg-dark text-white text-xs font-medium inline-flex items-center px-2.5 py-0.5 rounded dark:bg-dark">
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
              <% end %>
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
