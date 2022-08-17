defmodule LiveSupWeb.Live.Components.SmartRenderComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div>
      <%= if @widget_data.state == :error do %>
        <!-- Widget Error -->
        <div class="ring-1 shadow ring-red-500 ring-opacity-50 items-center justify-between bg-white rounded-md dark:bg-darker min-h-[202px]">
          <!-- Widget Error Detail -->
            <div class="bg-white rounded-md dark:bg-darker">
              <div class="flex items-center justify-between p-2 border-b dark:border-primary">
                <h4 class="text-base font-semibold text-gray-500 dark:text-light"><%= @widget_data.title %></h4>
                <%= if @widget_data.icon do %>
                <span><img class="w-4" src={@widget_data.icon} /></span>
                <% end %>
              </div>
              <div class="items-center p-6 text-center space-x-2">
                <p class="flex justify-center">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 mb-2 text-danger-darker" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                  </svg>
                </p>
                <p><%= @widget_data.data.error_description %></p>
              </div>
              <div class="px-2 py-1 border-t border-gray-700">
                <div class="space-x-2 text-right">
                  <span class="text-xs text-gray-500">Updated at <%= @widget_data.updated_in_minutes %></span>
                </div>
              </div>
            </div>
            <!-- /Widget Error Detail -->
        </div>
        <!-- /Widget Error -->
      <% end %>

      <%= if @widget_data.state == :in_progress do %>
        <!-- Widget Loading -->
        <div class="opacity-50 ring-1 shadow ring-indigo-300 ring-opacity-50 items-center justify-between bg-white rounded-md dark:bg-darker animate-pulse min-h-[202px]">
          <!-- Widget Loading Detail -->
            <div class="bg-white rounded-md dark:bg-darker">
              <div class="flex items-center justify-between p-2 border-b dark:border-primary">
                <h4 class="text-base font-semibold text-gray-500 dark:text-light"><%= @widget_data.title %></h4>
                <div class="flex items-right space-x-2">
                </div>
              </div>
              <div class="p-6 text-center space-x-2 dark:text-info-light">
                <p class="flex justify-center">
                  <svg class="animate-spin mb-2 h-12 w-12" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                </p>
                <p>Loading...</p>
              </div>
            </div>
            <!-- /Widget Loading Detail -->
        </div>
        <!-- /Widget Loading -->
      <% end %>

      <%= if @widget_data.state == :ready do %>
        <div id={"#{@widget_data.id}-widget"} class="bg-white rounded-md dark:bg-darker min-h-[202px]">
          <%= render_slot(@inner_block, @widget_data) %>
        </div>
      <% end %>
    </div>
    """
  end
end
