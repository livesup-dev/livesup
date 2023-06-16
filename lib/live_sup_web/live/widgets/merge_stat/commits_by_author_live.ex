defmodule LiveSupWeb.Live.Widgets.MergeStat.CommitsByAuthorsLive do
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
      <!-- Commits by author -->
      <WidgetHeaderComponent.render widget_data={widget_data} />
      <!-- Widget Content -->
      <div class="p-2 divide-y divide-gray-100 dark:divide-gray-500 ">
        <div :for={value <- widget_data.data} class="grid grid-cols-3 pt-1 pb-1">
          <p class="col-span-2 justify-self-start"><%= User.full_name(value["user"]) %></p>
          <p class="col-span-1 justify-self-end"><%= value["count"] %></p>
        </div>
        <!-- /Widget Content -->
      </div>
      <!-- /Commits by author -->
      <WidgetFooterComponent.render widget_data={widget_data} />
    </.live_component>
    """
  end
end
