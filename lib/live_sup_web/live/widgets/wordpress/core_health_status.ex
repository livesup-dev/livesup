defmodule LiveSupWeb.Live.Widgets.Wordpress.CoreHealthStatusLive do
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
      <!-- WordPress Core Health -->
      <WidgetHeaderComponent.render widget_data={widget_data} />
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
      <WidgetFooterComponent.render widget_data={widget_data} />
    </.live_component>
    """
  end
end
