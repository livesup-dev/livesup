defmodule LiveSupWeb.Helpers do
  use Phoenix.Component

  # alias LiveSupWeb.Router.Helpers, as: Routes

  @doc """
  Renders [Remix](https://remixicon.com) icon.
  ## Examples
      <.remix_icon icon="cpu-line" />
      <.remix_icon icon="cpu-line" class="align-middle mr-1" />
  """
  def remix_icon(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign(:attrs, assigns_to_attributes(assigns, [:icon, :class]))

    ~H"""
    <i class={"ri-#{@icon} #{@class}"} {@attrs}></i>
    """
  end

  @doc """
  Renders a checkbox input styled as a switch.
  Also, a hidden input with the same name is rendered
  alongside the checkbox, so the submitted value is
  always either `"true"` or `"false"`.
  ## Examples
      <.switch_checkbox
        name="likes_cats"
        label="I very much like cats"
        checked={@likes_cats} />
  """
  def switch_checkbox(assigns) do
    assigns =
      assigns
      |> assign_new(:label, fn -> nil end)
      |> assign_new(:disabled, fn -> false end)
      |> assign_new(:class, fn -> "" end)
      |> assign(
        :attrs,
        assigns_to_attributes(assigns, [:label, :name, :checked, :disabled, :class])
      )

    ~H"""
    <div class="flex space-x-3 items-center justify-between">
      <%= if @label do %>
        <span class="text-gray-700"><%= @label %></span>
      <% end %>
      <label class={"switch-button #{if(@disabled, do: "switch-button--disabled")}"}>
        <input type="hidden" value="false" name={@name} />
        <input
          type="checkbox"
          value="true"
          class={"switch-button__checkbox #{@class}"}
          name={@name}
          checked={@checked}
          {@attrs}
        />
        <div class="switch-button__bg"></div>
      </label>
    </div>
    """
  end

  @doc """
  Renders a choice button that is either active or not.
  ## Examples
      <.choice_button active={@tab == "my_tab"} phx-click="set_my_tab">
        My tab
      </.choice_button>
  """
  def choice_button(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:disabled, fn -> assigns.active end)
      |> assign(:attrs, assigns_to_attributes(assigns, [:active, :class, :disabled]))

    ~H"""
    <button
      class={"choice-button #{if(@active, do: "active")} #{@class}"}
      disabled={@disabled}
      {@attrs}
    >
      <%= render_block(@inner_block) %>
    </button>
    """
  end

  @doc """
  Renders a highlighted code snippet.
  ## Examples
      <.code_preview
        source_id="my-snippet"
        language="elixir"
        source="System.version()" />
  """
  def code_preview(assigns) do
    ~H"""
    <div class="markdown">
      <pre><code
        class="tiny-scrollbar"
        id={"#{@source_id}-highlight"}
        phx-hook="Highlight"
        data-language={@language}><div id={@source_id} data-source><%= @source %></div><div data-target></div></code></pre>
    </div>
    """
  end

  @doc """
  Renders text with a tiny label.
  ## Examples
      <.labeled_text label="Name" text="Sherlock Holmes" />
  """
  def labeled_text(assigns) do
    ~H"""
    <div class="flex flex-col space-y-1">
      <span class="text-xs text-gray-500">
        <%= @label %>
      </span>
      <span class="text-gray-800 text-sm font-semibold">
        <%= @text %>
      </span>
    </div>
    """
  end
end
