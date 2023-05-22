defmodule LiveSupWeb.Live.Widgets.Jira.ListOfIssuesLive do
  use LiveSupWeb.Live.Widgets.WidgetLive
  alias LiveSup.Views.JiraStateHelper
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
      <!-- Incidents by Type -->
      <WidgetHeaderComponent.render widget_data={widget_data} />
      <!-- Widget Content -->
      <div class="ls-widget-body-default">
        <div :if={Enum.any?(widget_data.data)}>
          <div class="gap-2 pb-2 flex">
            <span class="text-x font-bold basis-9/12">Issue</span>
            <span class="font-bold text-center basis-1/12">Created</span>
            <span class="font-bold text-center basis-2/12">Status</span>
          </div>
          <div class="divide-y divide-gray-100 dark:divide-gray-500 ">
            <%= for issue <- widget_data.data do %>
              <div class="gap-4 py-2 flex">
                <a
                  class="dark:text-primary hover:underline break-all basis-9/12"
                  target="_blank"
                  href={"#{widget_data.public_settings["domain"]}/browse/#{issue[:key]}"}
                  x-tooltip.light={"'#{issue[:summary]}'"}
                >
                  <%= Palette.Utils.StringHelper.truncate(issue[:summary], max_length: 35) %>
                </a>
                <span class="justify-center text-center basis-1/12">
                  <%= Palette.Utils.DateHelper.from_now(issue[:created_at], :short) %>
                </span>
                <span
                  class="justify-center text-center basis-2/12"
                  x-tooltip.light={"'#{issue[:status]}'"}
                >
                  <i class={JiraStateHelper.status_icon(issue[:status])} />
                </span>
              </div>
            <% end %>
          </div>
          <.empty_data_icon
            :if={Enum.empty?(widget_data.data)}
            svg_class="h-20 w-20"
            description="No Jira issues to be displayed."
          />
        </div>
      </div>
      <!-- /Widget Content -->
      <!-- /Incidents by Type -->
      <WidgetFooterComponent.render widget_data={widget_data} />
    </.live_component>
    """
  end
end
