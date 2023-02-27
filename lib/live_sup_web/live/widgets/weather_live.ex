defmodule LiveSupWeb.Live.Widgets.WeatherLive do
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
      <!-- Weather Start -->
      <!-- Card header -->
      <.live_component
        module={WidgetHeaderComponent}
        id={"#{widget_data.id}-header"}
        widget_data={widget_data}
      />
      <!-- /Card header -->
      <!-- Weather Start -->
      <div class="flex items-center p-2 bg-white rounded-md dark:bg-darker">
        <div class="flex-none m-4 items-center">
          <p class="text-sm text-center font-semibold"><%= widget_data.data.location %></p>
          <span>
            <img class="m-auto" src={widget_data.data.icon} width="64px" height="64px" />
          </span>
          <p class="text-3xl font-semibold text-center"><%= widget_data.data.feelslike %>&#8451;</p>
          <p class="text-sm text-center"><%= widget_data.data.condition %></p>
        </div>
        <div class="flex-auto m-4 grid grid-cols-1 text-sm divide-y dark:divide-blue-300">
          <p class="flex font-semibold justify-between py-2">
            <span>Temp</span><span><%= widget_data.data.temp %>&#8451;</span>
          </p>
          <p class="flex font-semibold justify-between py-2">
            <span>Wind</span><span><%= widget_data.data.wind_dir %> <%= widget_data.data.wind %>Kph</span>
          </p>
          <p class="flex font-semibold justify-between py-2">
            <span>Humidity</span><span><%= widget_data.data.humidity %>%</span>
          </p>
          <p class="flex font-semibold justify-between py-2">
            <span>Precip</span><span><%= widget_data.data.precip %>mm</span>
          </p>
        </div>
      </div>
      <!-- Weather End -->
      <.live_component
        module={WidgetFooterComponent}
        id={"#{widget_data.id}-footer"}
        widget_data={widget_data}
      />
    </.live_component>
    """
  end
end
