defmodule LiveSupWeb.Live.Widgets.TeamMembersLive do
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
      <!-- Team Members -->
      <WidgetHeaderComponent.render widget_data={widget_data} />
      <!-- Widget Content -->
      <div class="ls-widget-body-default">
        <div
          :if={Enum.any?(widget_data.data)}
          class="divide-y divide-gray-100 dark:divide-gray-500 max-h-80 overflow-auto"
        >
          <%= for user <- widget_data.data do %>
            <div class="flex py-2 first:pt-0 gap-3 flex-wrap dark:divide-blue-300">
              <div class="flex-none relative pt-1">
                <img
                  src={user[:avatar]}
                  class="w-8 h-8 rounded-full transition-opacity duration-200 "
                />
                <%= if user[:night] == true do %>
                  <i class="absolute bottom-0 right-0 rounded-full bg-slate-700 p-[1px]">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      class="h-4 w-4"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"
                      />
                    </svg>
                  </i>
                <% else %>
                  <i class="absolute bottom-0 right-0 rounded-full bg-slate-700 p-[1px]">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      class="h-4 w-4"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="rgb(252, 211, 77)"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"
                      />
                    </svg>
                  </i>
                <% end %>
              </div>
              <div class="grow">
                <p>
                  <span class="block font-medium"><%= user[:full_name] %></span>
                  <span class="text-xs align-middle inline-block">
                    <%= user[:address] %>
                  </span>
                  |
                  <span class="text-sm">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      class="h-4 w-4 inline-block"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
                      />
                    </svg>
                    <date class=" align-middle inline-block"><%= user[:now_str] %></date>
                  </span>
                </p>
              </div>
            </div>
          <% end %>
        </div>

        <p :if={length(widget_data.data) == 0} class="text-center m-2">This team has no members.</p>
      </div>
      <!-- /Widget Content -->
      <!-- /Team Members -->
      <WidgetFooterComponent.render widget_data={widget_data} />
    </.live_component>
    """
  end
end
