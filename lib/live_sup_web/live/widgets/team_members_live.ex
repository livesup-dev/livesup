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
      <.live_component
        module={WidgetHeaderComponent}
        id={"#{widget_data.id}-header"}
        widget_data={widget_data}
      />
      <!-- Widget Content -->
      <div class="ls-widget-body-default">
        <%= if Enum.any?(widget_data.data) do %>
          <div class="divide-y divide-gray-100 dark:divide-gray-500">
            <%= for user <- widget_data.data do %>
              <div class="flex py-4 first:pt-0 gap-3 flex-wrap dark:divide-blue-300">
                <div class="flex-none relative pt-1">
                  <img
                    src={user[:avatar]}
                    class="w-10 h-10 rounded-full transition-opacity duration-200 "
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
                    <strong class="block"><%= user[:full_name] %></strong>
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      class="h-4 w-4 inline-block"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                      stroke-width="2"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                      />
                    </svg>
                    <span class="text-sm align-middle inline-block">
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
        <% else %>
          <p class="text-center m-2">This team has no members.</p>
        <% end %>
      </div>
      <!-- /Widget Content -->
      <!-- /Team Members -->
      <.live_component
        module={WidgetFooterComponent}
        id={"#{widget_data.id}-footer"}
        widget_data={widget_data}
      />
    </.live_component>
    """
  end
end
