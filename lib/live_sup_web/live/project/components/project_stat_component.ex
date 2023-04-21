defmodule LiveSupWeb.Project.Components.ProjectStatComponent do
  use LiveSupWeb, :component

  attr(:label, :string, required: false, default: "")
  attr(:tooltip, :string, required: false, default: "")
  attr(:value, :integer, required: true)
  attr(:icon, :string, required: true)
  attr(:color, :string, required: true)

  def render(%{value: value, color: color, tooltip: tooltip} = assigns) do
    color =
      case value do
        0 -> "stone-300"
        _ -> color
      end

    tooltip =
      case tooltip do
        "" -> false
        _ -> "'#{tooltip}'"
      end

    assigns =
      assigns
      |> assign(:color, color)
      |> assign(:tooltip, tooltip)

    ~H"""
    <div class="flex items-center space-x-2 rounded-2xl p-4">
      <div
        x-tooltip={@tooltip}
        class={"mask is-star-2 flex h-8 w-8 items-center justify-center bg-#{@color}/10 dark:bg-#{@color}"}
      >
        <i class={"h-4 w-4 #{@icon} text-#{@color} dark:text-white"}></i>
      </div>
      <div class="font-inter">
        <p class="text-base font-semibold text-slate-700 dark:text-navy-100">
          <%= @value %>
        </p>
        <%= if @label do %>
          <p class="text-xs text-slate-500 dark:text-navy-400">
            <%= @label %>
          </p>
        <% end %>
      </div>
    </div>
    """
  end
end
