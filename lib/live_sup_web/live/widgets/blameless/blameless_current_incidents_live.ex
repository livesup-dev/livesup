defmodule LiveSupWeb.Live.Widgets.Blameless.CurrentIncidentsLive do
  use LiveSupWeb.Live.Widgets.WidgetLive
  alias LiveSupWeb.Widgets.Blameless.BlamelessHelper

  @impl true
  def render_widget(assigns) do
    ~H"""
    <.live_component
      :let={widget_data}
      module={SmartRenderComponent}
      id={@widget_data.id}
      widget_data={@widget_data}
    >
      <!-- Current Incidents -->
      <.live_component
        module={WidgetHeaderComponent}
        id={"#{widget_data.id}-header"}
        widget_data={widget_data}
      />
      <!-- Widget Content -->
      <div class="ls-widget-body-default">
        <%= if Enum.any?(widget_data.data) do %>
          <%= for {incident, _counter} <- Enum.with_index(widget_data.data) do %>
            <div class={"flex flex-col justify-between border-4 border-transparent #{BlamelessHelper.severity_border_color(incident[:severity])} px-4 mt-4 mb-8 relative"}>
              <span class="absolute -left-2 -top-1 flex h-3 w-3">
                <span class={"animate-ping absolute inline-flex h-full w-full rounded-full #{BlamelessHelper.severity_bg_ping_color(incident[:severity])}"}>
                </span>
              </span>
              <div>
                <p class="text-base font-medium text-slate-600 dark:text-navy-100">
                  <a
                    href={incident[:url]}
                    class="hover:underline text-black dark:text-primary block"
                    target="_blank"
                  >
                    <%= incident[:description] %>
                  </a>
                </p>
                <p class="text-xs text-slate-400 dark:text-navy-300">
                  <%= incident[:created_at_ago] %>
                </p>
                <div class={"badge mt-2 #{BlamelessHelper.severity_color(incident[:severity])} #{BlamelessHelper.severity_bg_color(incident[:severity])}"}>
                  <%= incident[:severity] %>
                </div>
                <div class={"badge mt-2 bg-secondary/10 text-secondary dark:bg-secondary-light/15 dark:text-secondary-light incident-#{String.downcase(incident[:status])} bg-incident-#{String.downcase(incident[:status])}/10"}>
                  <%= incident[:status] %>
                </div>
              </div>
              <div>
                <div class="mt-4">
                  <p class="font-inter">
                    <%= if incident.slack && incident.slack[:url] do %>
                      <span class="font-mono text-sm text-black dark:text-white block">
                        <a
                          href={incident.slack[:url]}
                          target="_blank"
                          class="hover:underline text-black dark:text-primary inline-block"
                        >
                          <svg
                            class="w-4 h-4 rounded-full inline-block mr-2"
                            version="1.1"
                            xmlns="http://www.w3.org/2000/svg"
                            xmlns:xlink="http://www.w3.org/1999/xlink"
                            x="0px"
                            y="0px"
                            viewBox="60 60 140 140"
                            style="enable-background:new 60 60 140 140; display:inline-block;"
                            xml:space="preserve"
                          >
                            <style type="text/css">
                              .st0{fill:#E01E5A;}
                              .st1{fill:#36C5F0;}
                              .st2{fill:#2EB67D;}
                              .st3{fill:#ECB22E;}
                            </style>
                            <g>
                              <g>
                                <path
                                  class="st0"
                                  d="M99.4,151.2c0,7.1-5.8,12.9-12.9,12.9c-7.1,0-12.9-5.8-12.9-12.9c0-7.1,5.8-12.9,12.9-12.9h12.9V151.2z"
                                />
                                <path
                                  class="st0"
                                  d="M105.9,151.2c0-7.1,5.8-12.9,12.9-12.9s12.9,5.8,12.9,12.9v32.3c0,7.1-5.8,12.9-12.9,12.9
                                  s-12.9-5.8-12.9-12.9V151.2z"
                                />
                              </g>
                              <g>
                                <path
                                  class="st1"
                                  d="M118.8,99.4c-7.1,0-12.9-5.8-12.9-12.9c0-7.1,5.8-12.9,12.9-12.9s12.9,5.8,12.9,12.9v12.9H118.8z"
                                />
                                <path
                                  class="st1"
                                  d="M118.8,105.9c7.1,0,12.9,5.8,12.9,12.9s-5.8,12.9-12.9,12.9H86.5c-7.1,0-12.9-5.8-12.9-12.9
                                  s5.8-12.9,12.9-12.9H118.8z"
                                />
                              </g>
                              <g>
                                <path
                                  class="st2"
                                  d="M170.6,118.8c0-7.1,5.8-12.9,12.9-12.9c7.1,0,12.9,5.8,12.9,12.9s-5.8,12.9-12.9,12.9h-12.9V118.8z"
                                />
                                <path
                                  class="st2"
                                  d="M164.1,118.8c0,7.1-5.8,12.9-12.9,12.9c-7.1,0-12.9-5.8-12.9-12.9V86.5c0-7.1,5.8-12.9,12.9-12.9
                                  c7.1,0,12.9,5.8,12.9,12.9V118.8z"
                                />
                              </g>
                              <g>
                                <path
                                  class="st3"
                                  d="M151.2,170.6c7.1,0,12.9,5.8,12.9,12.9c0,7.1-5.8,12.9-12.9,12.9c-7.1,0-12.9-5.8-12.9-12.9v-12.9H151.2z"
                                />
                                <path
                                  class="st3"
                                  d="M151.2,164.1c-7.1,0-12.9-5.8-12.9-12.9c0-7.1,5.8-12.9,12.9-12.9h32.3c7.1,0,12.9,5.8,12.9,12.9
                                  c0,7.1-5.8,12.9-12.9,12.9H151.2z"
                                />
                              </g>
                            </g>
                          </svg>
                          <%= incident.slack[:channel] %>
                        </a>
                      </span>
                    <% end %>
                  </p>
                </div>
                <div class="mt-6 flex items-center justify-between space-x-2">
                  <%= if incident.commander && incident.commander[:full_name] do %>
                    <div class="flex">
                      <div class="avatar h-10 w-10">
                        <img
                          src={incident.commander[:avatar_url]}
                          class="rounded-full ring ring-white dark:ring-navy-700"
                          alt="avatar"
                        />
                      </div>
                      <div class="text-sm flex-grow ml-2">
                        <p class="block"><%= incident.commander[:full_name] %></p>
                        <p class="text-xs block">
                          <%= commander_title(incident.commander) %>
                        </p>
                      </div>
                    </div>
                  <% else %>
                    <div class="avatar h-8 w-8">
                      <div class="is-initial rounded-full bg-success text-xs+ uppercase text-white ring ring-white dark:ring-navy-700">
                        N/A
                      </div>
                    </div>
                  <% end %>
                </div>
              </div>
            </div>
          <% end %>
        <% else %>
          <div class="py-4">
            <svg
              class="h-20 w-20 m-auto"
              viewBox="0 0 81 80"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                d="M66.5 34.6667C66.8333 36.3334 67.1667 38.3334 67.1667 40.0001C67.1667 54.6668 55.1667 66.6668 40.5 66.6668C25.8333 66.6668 13.8333 54.6668 13.8333 40.0001C13.8333 25.3334 25.8333 13.3334 40.5 13.3334C45.8333 13.3334 51.1667 15.0001 55.1667 17.6667L59.8333 13.0001C54.5 9.00008 47.8333 6.66675 40.5 6.66675C22.1667 6.66675 7.16666 21.6667 7.16666 40.0001C7.16666 58.3334 22.1667 73.3334 40.5 73.3334C58.8333 73.3334 73.8333 58.3334 73.8333 40.0001C73.8333 36.3334 73.1667 32.6667 72.1667 29.3334L66.5 34.6667Z"
                fill="#21D3EE"
              />
              <path
                d="M37.1667 54.6667L21.5 39L26.1667 34.3333L37.1667 45.3333L71.5 11L76.1667 15.6667L37.1667 54.6667Z"
                fill="#21D3EE"
              />
              <path
                opacity="0.3"
                d="M40.5 6.66675C31.6594 6.66675 23.181 10.1786 16.9298 16.4299C10.6786 22.6811 7.16666 31.1595 7.16666 40.0001C7.16666 48.8406 10.6786 57.3191 16.9298 63.5703C23.181 69.8215 31.6594 73.3334 40.5 73.3334C49.3405 73.3334 57.819 69.8215 64.0702 63.5703C70.3214 57.3191 73.8333 48.8406 73.8333 40.0001C73.8333 31.1595 70.3214 22.6811 64.0702 16.4299C57.819 10.1786 49.3405 6.66675 40.5 6.66675Z"
                fill="#21D3EE"
              />
            </svg>
            <p class="text-center m-2">No Incidents to Display</p>
          </div>
        <% end %>
      </div>
      <!-- /Widget Content -->
      <.live_component
        module={WidgetFooterComponent}
        id={"#{widget_data.id}-footer"}
        widget_data={widget_data}
      />
      <!-- /Current Incidents -->
    </.live_component>
    """
  end

  def commander_title(%{title: ""}), do: ""
  def commander_title(%{title: title}), do: "(#{title})"
end
