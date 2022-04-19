defmodule LiveSupWeb.Live.Widgets.PagerDuty.OnCallLive do
  use LiveSupWeb.Live.Widgets.WidgetLive

  @impl true
  def render_widget(assigns) do
    ~H"""
    <.live_component module={SmartRenderComponent} id={@widget_data.id}  let={widget_data} widget_data={@widget_data}>
      <!-- Metrics Goal -->
      <.live_component module={WidgetHeaderComponent} id={"#{widget_data.id}-header"} widget_data={widget_data} />
      <!-- Widget Content -->
      <div class="p-2 grid justify-items-center">

        <%= for on_calls <- widget_data.data do %>

          <div class="card w-96 hover:shadow-none relative flex flex-col mx-auto shadow-lg m-5">
            <div class="profile w-full flex m-3 ml-4 text-white">
              <img class="w-16 h-16 p-1 bg-white rounded-full" src={on_calls.user[:avatar_url]} alt=""/>
              <div class="title mt-11 ml-3 font-bold flex flex-col">
                <div class="name break-words"><%= on_calls.user[:name] %></div>
                <!--  add [dark] class for bright background -->
                <div class="add font-semibold text-sm italic dark">From: <%= format_date(on_calls[:start]) %>, to: <%= format_date(on_calls[:end]) %></div>
              </div>
            </div>

          </div>

        <% end %>
      </div>
      <!-- /Widget Content -->
      <!-- /Metrics Goal -->
        <.live_component module={WidgetFooterComponent} id={"#{widget_data.id}-footer"} widget_data={widget_data} />
    </.live_component>
    """
  end

  def format_date(date) do
    LiveSup.Helpers.DateHelper.date_without_year(date)
  end
end
