defmodule LiveSupWeb.Live.Components.WidgetHeaderComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-between p-2 border-b dark:border-primary">
    <h4 class="text-base font-semibold text-gray-500 dark:text-light"><%= @widget_data.title %></h4>
    <div class="flex items-right space-x-2">
      <%= if @widget_data.icon do %>
      <span><img class="w-4" src={@widget_data.icon} /></span>
      <% end %>
      <%= Phoenix.HTML.raw(@widget_data.icon_svg) %>
      </div>
    </div>
    """
  end
end
