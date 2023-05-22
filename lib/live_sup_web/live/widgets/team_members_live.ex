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
              </div>
              <div class="grow">
                <p>
                  <span class="block font-medium"><%= user[:full_name] %></span>
                  <span class="text-xs align-middle inline-block">
                    <%= user[:address] %>
                  </span>
                  <span class="text-grey-200">|</span>
                  <i class={"h-4 w-4 #{day_icon(user)}"}></i>
                  <span class="text-grey-200">|</span>
                  <span class="text-sm">
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

  def day_icon(%{night: true}) do
    "fa-solid fa-moon text-grey-400"
  end

  def day_icon(%{night: false}) do
    "fa-solid fa-sun text-yellow-400"
  end
end
