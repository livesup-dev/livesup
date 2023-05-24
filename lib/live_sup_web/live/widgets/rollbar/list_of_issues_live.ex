defmodule LiveSupWeb.Live.Widgets.Rollbar.ListOfIssuesLive do
  use LiveSupWeb.Live.Widgets.WidgetLive
  import LiveSupWeb.Components.IconsComponent

  @impl true
  def render_widget(assigns) do
    ~H"""
    <.live_component
      :let={widget_data}
      module={SmartRenderComponent}
      id={@widget_data.id}
      widget_data={@widget_data}
    >
      <!-- Rollbar list of issues -->
      <WidgetHeaderComponent.render widget_data={widget_data} />
      <div class="ls-widget-body-default">
        <div :if={Enum.any?(widget_data.data)}>
          <div class="gap-2 pb-2 flex">
            <span class="text-x font-bold basis-9/12">Error</span>
            <span class="font-bold text-center basis-2/12">Total</span>
            <span class="font-bold text-center basis-1/12">Last</span>
          </div>
          <div class="divide-y divide-gray-100 dark:divide-gray-500 ">
            <%= for issue <- widget_data.data do %>
              <div class="gap-4 py-2 flex">
                <a
                  class="dark:text-primary hover:underline break-all basis-9/12"
                  target="_blank"
                  href={issue[:url]}
                >
                  <%= issue[:short_title] %>
                </a>
                <span class="justify-center text-center basis-2/12">
                  <%= issue[:total_occurrences] %>
                </span>
                <span class="justify-center text-center basis-1/12">
                  <%= issue[:last_occurrence_ago] %>
                </span>
              </div>
            <% end %>
          </div>
        </div>
        <.empty_data_icon
          :if={Enum.empty?(widget_data.data)}
          svg_class="h-20 w-20"
          description="No Rollbar issues to be displayed."
        />
      </div>
      <!-- /Widget Content -->
      <!-- /Rollbar list of issues -->
      <WidgetFooterComponent.render widget_data={widget_data} />
    </.live_component>
    """
  end
end
