defmodule LiveSupWeb.Live.Components.WidgetHeaderComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="ls-widget-title">
      <h2><%= @widget_data.title %></h2>
      <div class="flex items-right space-x-2">
        <%= if @widget_data.icon do %>
          <span><img class="w-4" src={@widget_data.icon} /></span>
        <% end %>

        <%= if assigns[:icon_svg] do %>
          <%= Phoenix.HTML.raw(@icon_svg) %>
        <% end %>
      </div>
    </div>
    """
  end
end
