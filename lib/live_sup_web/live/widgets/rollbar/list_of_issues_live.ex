defmodule LiveSupWeb.Live.Widgets.Rollbar.ListOfIssuesLive do
  use LiveSupWeb.Live.Widgets.WidgetLive

  @impl true
  def render_widget(assigns) do
    ~H"""
    <.live_component module={SmartRenderComponent} id={@widget_data.id} let={widget_data} widget_data={@widget_data}>
      <!-- Rollbar list of issues -->
        <.live_component module={WidgetHeaderComponent} id={"#{widget_data.id}-header"} widget_data={widget_data} />
        <div class="items-center p-4 bg-white rounded-md dark:bg-darker">
          <div class="grid grid-cols-1 dark:divide-blue-300">
            <div class="gap-2 pb-2 flex">
              <span class="text-x font-bold basis-1/2">Error</span>
              <span class="font-bold text-center basis-1/4">Ocurrences</span>
              <span class="font-bold text-center basis-1/4">Last</span>
            </div>
              <%= for issue <- widget_data.data do %>
              <div class="gap-2 py-2 flex">
                <a class="text-blue-500 hover:underline text-stone-400 items-center basis-1/2" href={issue[:url]}><%= issue[:short_title] %></a>
                <span class="justify-center items-center basis-1/4"><%= issue[:total_occurrences] %></span>
                <span class="justify-center items-center basis-1/4"><%= issue[:last_occurrence_ago] %></span>
              </div>
              <% end %>
          </div>
        </div>
        <!-- /Widget Content -->
      <!-- /Rollbar list of issues -->
        <.live_component module={WidgetFooterComponent} id={"#{widget_data.id}-footer"} widget_data={widget_data} />
    </.live_component>
    """
  end
end
