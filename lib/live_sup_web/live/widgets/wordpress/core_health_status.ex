defmodule LiveSupWeb.Live.Widgets.Wordpress.CoreHealthStatusLive do
  use LiveSupWeb.Live.Widgets.WidgetLive

  @impl true
  def render_widget(assigns) do
    ~H"""
    <.live_component
      module={SmartRenderComponent}
      id="core-health-status"
      :let={widget_data}
      widget_data={@widget_data}
    >
      <!-- WordPress Core Health -->
      <.live_component
        module={WidgetHeaderComponent}
        id={"#{widget_data.id}-header"}
        widget_data={widget_data}
      />
      <!-- Widget Content -->
      <div class="flex-1 grid grid-cols-1 divide-y divide-gray-100 dark:divide-gray-500 text-sm p-2">
        <%= for {_key, value} <- widget_data.data[:wp_core] do %>
          <p class="flex font-semibold justify-between py-2">
            <span><%= value[:label] %></span><span class="text-xs"><%= value[:value] %></span>
          </p>
        <% end %>
      </div>
      <!-- /Widget Content -->
      <!-- /WordPress Core Health -->
      <.live_component
        module={WidgetFooterComponent}
        id={"#{widget_data.id}-footer"}
        widget_data={widget_data}
      />
    </.live_component>
    """
  end
end
