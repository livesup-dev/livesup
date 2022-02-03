defmodule LiveSupWeb.Live.Widgets.Blameless.LastIncidentsLive do
  use LiveSupWeb.Live.Widgets.WidgetLive
  alias LiveSupWeb.Widgets.Blameless.BlamelessHelper

  @impl true
  def render_widget(assigns) do
    ~H"""
    <.live_component module={SmartRenderComponent} id={@widget_data.id}  let={widget_data} widget_data={@widget_data}>
      <!-- Last Incidents -->
        <.live_component module={WidgetHeaderComponent} id={"#{widget_data.id}-header"} widget_data={widget_data} />
        <!-- Widget Content -->
          <div class="flex-auto divide-y divide-gray-100 dark:divide-dark p-1">
          <%= for {incident, counter} <- Enum.with_index(widget_data.data) do %>
            <div class="flex p-2">
              <div class={"flex h-auto w-2 #{BlamelessHelper.pull_request_color(incident[:created_at])}"}></div>
              <div class="flex-auto pl-2">
                <p class="text-abse"><a href={incident[:url]} class="text-blue-500 hover:underline text-stone-400"><%= incident[:description] %></a></p>
                <p class="font-mono text-xs text-gray-500 dark:text-primary-light"><%= incident[:severity] %> - <%= incident[:created_at_ago] %> / <%= incident[:commander][:full_name] %></p>
              </div>
            </div>
          <% end %>
        </div>
        <!-- /Widget Content -->
        <.live_component module={WidgetFooterComponent} id={"#{widget_data.id}-footer"} widget_data={widget_data} />
      <!-- /Last Incidents -->
    </.live_component>
    """
  end
end
