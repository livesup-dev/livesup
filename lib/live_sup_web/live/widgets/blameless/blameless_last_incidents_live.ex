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
        <div class="items-center p-2 bg-white rounded-md dark:bg-darker min-h-[132px]">
          <%= if Enum.any?(widget_data.data) do %>
            <div class="divide-y divide-gray-100 dark:divide-gray-500">
              <%= for {incident, counter} <- Enum.with_index(widget_data.data) do %>
                <div class="flex py-4 first:pt-0 gap-4 flex-wrap dark:divide-gray-500">
                  <div class="flex">
                    <div class="flex-auto">
                      <p>
                        <a href={incident[:url]} class="hover:underline text-black dark:text-primary"><%= incident[:description] %></a>
                        <span class="font-mono text-sm text-black dark:text-white"> - <%= incident[:created_at_ago] %></span>
                      </p>
                      <p>
                        <span class="font-mono text-sm text-black dark:text-white ">
                        <a href={incident.slack[:url]} target="_blank" class="hover:underline text-black dark:text-primary inline-block">
                          <svg class="w-6 h-6 rounded-full inline-block mr-2" version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
                            viewBox="60 60 140 140" style="enable-background:new 60 60 140 140; display:inline-block;" xml:space="preserve">
                            <style type="text/css">
                              .st0{fill:#E01E5A;}
                              .st1{fill:#36C5F0;}
                              .st2{fill:#2EB67D;}
                              .st3{fill:#ECB22E;}
                            </style>
                            <g>
                              <g>
                                <path class="st0" d="M99.4,151.2c0,7.1-5.8,12.9-12.9,12.9c-7.1,0-12.9-5.8-12.9-12.9c0-7.1,5.8-12.9,12.9-12.9h12.9V151.2z"/>
                                <path class="st0" d="M105.9,151.2c0-7.1,5.8-12.9,12.9-12.9s12.9,5.8,12.9,12.9v32.3c0,7.1-5.8,12.9-12.9,12.9
                                  s-12.9-5.8-12.9-12.9V151.2z"/>
                              </g>
                              <g>
                                <path class="st1" d="M118.8,99.4c-7.1,0-12.9-5.8-12.9-12.9c0-7.1,5.8-12.9,12.9-12.9s12.9,5.8,12.9,12.9v12.9H118.8z"/>
                                <path class="st1" d="M118.8,105.9c7.1,0,12.9,5.8,12.9,12.9s-5.8,12.9-12.9,12.9H86.5c-7.1,0-12.9-5.8-12.9-12.9
                                  s5.8-12.9,12.9-12.9H118.8z"/>
                              </g>
                              <g>
                                <path class="st2" d="M170.6,118.8c0-7.1,5.8-12.9,12.9-12.9c7.1,0,12.9,5.8,12.9,12.9s-5.8,12.9-12.9,12.9h-12.9V118.8z"/>
                                <path class="st2" d="M164.1,118.8c0,7.1-5.8,12.9-12.9,12.9c-7.1,0-12.9-5.8-12.9-12.9V86.5c0-7.1,5.8-12.9,12.9-12.9
                                  c7.1,0,12.9,5.8,12.9,12.9V118.8z"/>
                              </g>
                              <g>
                                <path class="st3" d="M151.2,170.6c7.1,0,12.9,5.8,12.9,12.9c0,7.1-5.8,12.9-12.9,12.9c-7.1,0-12.9-5.8-12.9-12.9v-12.9H151.2z"/>
                                <path class="st3" d="M151.2,164.1c-7.1,0-12.9-5.8-12.9-12.9c0-7.1,5.8-12.9,12.9-12.9h32.3c7.1,0,12.9,5.8,12.9,12.9
                                  c0,7.1-5.8,12.9-12.9,12.9H151.2z"/>
                              </g>
                            </g>
                          </svg><%= incident.slack[:channel] %>
                        </a>
                      </span>
                      </p>
                    </div>
                  </div>
                  <%= if incident.commander do %>
                  <div>
                      <p class="text-sm">
                        <img src={incident.commander[:avatar_url]} class="w-6 h-6 rounded-full transition-opacity duration-200 inline-block mr-2"/>
                        <span class="inline"><%= incident.commander[:full_name] %></span>
                        <span class="text-xs inline">(<%= incident.commander[:title] %>)</span>
                      </p>
                  </div>
                  <% end %>
                </div>
              <% end %>
            </div>
          <% else %>
            <svg class="h-20 w-20 m-auto" viewBox="0 0 81 80" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M66.5 34.6667C66.8333 36.3334 67.1667 38.3334 67.1667 40.0001C67.1667 54.6668 55.1667 66.6668 40.5 66.6668C25.8333 66.6668 13.8333 54.6668 13.8333 40.0001C13.8333 25.3334 25.8333 13.3334 40.5 13.3334C45.8333 13.3334 51.1667 15.0001 55.1667 17.6667L59.8333 13.0001C54.5 9.00008 47.8333 6.66675 40.5 6.66675C22.1667 6.66675 7.16666 21.6667 7.16666 40.0001C7.16666 58.3334 22.1667 73.3334 40.5 73.3334C58.8333 73.3334 73.8333 58.3334 73.8333 40.0001C73.8333 36.3334 73.1667 32.6667 72.1667 29.3334L66.5 34.6667Z" fill="#21D3EE"/>
              <path d="M37.1667 54.6667L21.5 39L26.1667 34.3333L37.1667 45.3333L71.5 11L76.1667 15.6667L37.1667 54.6667Z" fill="#21D3EE"/>
              <path opacity="0.3" d="M40.5 6.66675C31.6594 6.66675 23.181 10.1786 16.9298 16.4299C10.6786 22.6811 7.16666 31.1595 7.16666 40.0001C7.16666 48.8406 10.6786 57.3191 16.9298 63.5703C23.181 69.8215 31.6594 73.3334 40.5 73.3334C49.3405 73.3334 57.819 69.8215 64.0702 63.5703C70.3214 57.3191 73.8333 48.8406 73.8333 40.0001C73.8333 31.1595 70.3214 22.6811 64.0702 16.4299C57.819 10.1786 49.3405 6.66675 40.5 6.66675Z" fill="#21D3EE"/>
            </svg>
            <p class="text-center m-2">No Incidents to Display</p>
          <% end %>
        </div>
        <!-- /Widget Content -->
        <.live_component module={WidgetFooterComponent} id={"#{widget_data.id}-footer"} widget_data={widget_data} />
      <!-- /Last Incidents -->
    </.live_component>
    """
  end
end
