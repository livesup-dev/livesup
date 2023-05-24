defmodule LiveSupWeb.Live.Widgets.Blameless.LastIncidentsLive do
  use LiveSupWeb.Live.Widgets.WidgetLive
  alias LiveSupWeb.Widgets.Blameless.BlamelessHelper
  alias LiveSupWeb.Live.Components.{WidgetHeaderComponent, WidgetFooterComponent}
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
      <!-- Last Incidents -->
      <WidgetHeaderComponent.render widget_data={widget_data} />
      <!-- Widget Content -->
      <div class="ls-widget-body-default">
        <div :if={Enum.any?(widget_data.data)}>
          <%= for {incident, _counter} <- Enum.with_index(widget_data.data) do %>
            <div class={"flex flex-col justify-between border-4 border-transparent #{BlamelessHelper.severity_border_color(incident[:severity])} px-4 mt-4 mb-8 relative"}>
              <span class="absolute -left-2 -top-1 flex h-3 w-3">
                <span class={"animate-ping absolute inline-flex h-full w-full rounded-full #{BlamelessHelper.severity_bg_ping_color(incident[:severity])}"}>
                </span>
              </span>
              <div id="incident">
                <div class="flex justify-between space-x-2 items-start">
                  <p class="text-base font-medium text-slate-600 dark:text-navy-100">
                    <a
                      href={incident[:url]}
                      class="hover:underline text-black dark:text-primary block"
                      target="_blank"
                    >
                      <%= incident[:description] %>
                    </a>
                  </p>
                  <div :if={incident.slack && incident.slack[:url]} id="social-media">
                    <a
                      href={incident.slack[:url]}
                      target="_blank"
                      class="hover:underline text-xs dark:text-primary inline-block"
                      x-tooltip={"'#{incident.slack[:channel]}'"}
                    >
                      <.slack_colored_icon svg_class="h-4 w-4 rounded-full" />
                      <span class="hidden">Slack Channel</span>
                    </a>
                  </div>
                </div>
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
                <div
                  :if={incident.commander && incident.commander[:full_name]}
                  class="mt-4 flex items-center justify-between space-x-2"
                >
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
                  <div :if={!incident.commander} class="avatar h-10 w-10">
                    <div class="is-initial rounded-full bg-success text-xs+ uppercase text-white ring ring-white dark:ring-navy-700">
                      N/A
                    </div>
                  </div>
                </div>
              </div>
            </div>
          <% end %>
        </div>
        <.empty_data_icon
          :if={Enum.empty?(widget_data.data)}
          class="py-4"
          svg_class="h-14 w-14"
          description="No Incidents to be displayed."
        />
      </div>
      <!-- /Widget Content -->
      <WidgetFooterComponent.render widget_data={widget_data} />
      <!-- /Last Incidents -->
    </.live_component>
    """
  end

  def commander_title(%{title: ""}), do: ""
  def commander_title(%{title: title}), do: "(#{title})"
end
