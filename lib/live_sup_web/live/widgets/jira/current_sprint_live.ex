defmodule LiveSupWeb.Live.Widgets.Jira.CurrentSprintLive do
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
      <!-- Jira Current Sprint -->
      <.live_component
        module={WidgetHeaderComponent}
        id={"#{widget_data.id}-header"}
        widget_data={widget_data}
      />
      <!-- Widget Content -->
      <div class="p-2 text-left min-h-[132px]">
        <span class="text-center text-lg"><%= widget_data.data.name %></span>
        <%= if widget_data.data.goal do %>
          <p class="text-sm text-stone-400"><%= widget_data.data.goal %></p>
        <% end %>
        <%= if widget_data.data.days_left == 0 do %>
          <p class="text-center text-3xl font-semibold mt-3 mb-3 text-gray-500 dark:text-primary-light">
            Last day of the sprint
          </p>
        <% else %>
          <p class="text-center text-3xl font-semibold mt-3 mb-3 text-gray-500 dark:text-primary-light">
            <%= widget_data.data.days_left %> days remaining
          </p>
        <% end %>
      </div>
      <!-- /Widget Content -->
      <!-- /Jira Current Sprint -->
      <.live_component
        module={WidgetFooterComponent}
        id={"#{widget_data.id}-footer"}
        widget_data={widget_data}
      />
    </.live_component>
    """
  end
end
