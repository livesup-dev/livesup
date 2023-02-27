defmodule LiveSupWeb.Live.Widgets.Wordpress.DirectorySizesLive do
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
      <!-- WordPress Directory Sizes -->
      <.live_component
        module={WidgetHeaderComponent}
        id={"#{widget_data.id}-header"}
        widget_data={widget_data}
      />
      <!-- Widget Content -->
      <div class="flex-1 grid grid-cols-1 divide-y divide-gray-100 dark:divide-gray-500 text-sm p-2">
        <%= for {key, value} <- widget_data.data do %>
          <p class="flex font-semibold justify-between py-2">
            <span><%= key %></span><span class="text-xs"><%= Map.get(value, "size") %></span>
          </p>
        <% end %>
      </div>
      <!-- /Widget Content -->
      <!-- /WordPress Directory Sizes -->
      <.live_component
        module={WidgetFooterComponent}
        id={"#{widget_data.id}-footer"}
        widget_data={widget_data}
      />
    </.live_component>
    """
  end
end
