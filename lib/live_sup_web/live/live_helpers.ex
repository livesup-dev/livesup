defmodule LiveSupWeb.LiveHelpers do
  use Phoenix.Component
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(
      to: "##{id}",
      display: "inline-block",
      transition: {"ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> JS.show(
      to: "##{id}-container",
      display: "inline-block",
      transition:
        {"ease-out duration-300", "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
    |> js_exec("##{id}-confirm", "focus", [])
  end

  def js_exec(js \\ %JS{}, to, call, args) do
    JS.dispatch(js, "js:exec", to: to, detail: %{call: call, args: args})
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.remove_class("fade-in", to: "##{id}")
    |> JS.hide(
      to: "##{id}",
      transition: {"ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> JS.hide(
      to: "##{id}-container",
      transition:
        {"ease-in duration-200", "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
    |> JS.dispatch("click", to: "##{id} [data-modal-return]")
  end

  attr :name, :atom, required: true
  attr :outlined, :boolean, default: false
  attr :rest, :global, default: %{class: "w-4 h-4 inline-block"}

  def icon(assigns) do
    assigns = assign_new(assigns, :"aria-hidden", fn -> !Map.has_key?(assigns, :"aria-label") end)

    ~H"""
    <%= if @outlined do %>
      <%= apply(Heroicons.Outline, @name, [Map.to_list(@rest)]) %>
    <% else %>
      <%= apply(Heroicons.Solid, @name, [Map.to_list(@rest)]) %>
    <% end %>
    """
  end

  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :patch, :string, default: nil
  attr :navigate, :string, default: nil
  attr :on_cancel, JS, default: %JS{}
  attr :on_confirm, JS, default: %JS{}
  # slots
  attr :title, :list, default: []
  attr :confirm, :list, default: []
  attr :cancel, :list, default: []
  attr :rest, :global

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      class={"fixed z-10 inset-0 overflow-y-auto #{if @show, do: "fade-in", else: "hidden"}"}
      {@rest}
    >
      <.focus_wrap id={"#{@id}-focus-wrap"} content={"##{@id}-container"}>
        <div
          class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0"
          aria-labelledby={"#{@id}-title"}
          aria-describedby={"#{@id}-description"}
          role="dialog"
          aria-modal="true"
          tabindex="0"
        >
          <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true">
          </div>
          <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">
            &#8203;
          </span>
          <div
            id={"#{@id}-container"}
            class={
              "#{if @show, do: "fade-in-scale", else: "hidden"} sticky inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform sm:my-8 sm:align-middle sm:max-w-xl sm:w-full sm:p-6"
            }
            phx-window-keydown={hide_modal(@on_cancel, @id)}
            phx-key="escape"
            phx-click-away={hide_modal(@on_cancel, @id)}
          >
            <%= if @patch do %>
              <.link patch={@patch} data-modal-return class="hidden"></.link>
            <% end %>
            <%= if @navigate do %>
              <.link navigate={@navigate} data-modal-return class="hidden"></.link>
            <% end %>
            <div class="sm:flex sm:items-start">
              <div class="mx-auto flex-shrink-0 flex items-center justify-center h-8 w-8 rounded-full bg-purple-100 sm:mx-0">
                <!-- Heroicon name: outline/plus -->
                <.icon name={:information_circle} outlined class="h-6 w-6 text-purple-600" />
              </div>
              <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left w-full mr-12">
                <h3 class="text-lg leading-6 font-medium text-gray-900" id={"#{@id}-title"}>
                  <%= render_slot(@title) %>
                </h3>
                <div class="mt-2">
                  <p id={"#{@id}-content"} class="text-sm text-gray-500">
                    <%= render_slot(@inner_block) %>
                  </p>
                </div>
              </div>
            </div>
            <div class="mt-5 sm:mt-4 sm:flex sm:flex-row-reverse">
              <%= for confirm <- @confirm do %>
                <button
                  id={"#{@id}-confirm"}
                  class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm"
                  phx-click={@on_confirm}
                  phx-disable-with
                  {assigns_to_attributes(confirm)}
                >
                  <%= render_slot(confirm) %>
                </button>
              <% end %>
              <%= for cancel <- @cancel do %>
                <button
                  class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:w-auto sm:text-sm"
                  phx-click={hide_modal(@on_cancel, @id)}
                  {assigns_to_attributes(cancel)}
                >
                  <%= render_slot(cancel) %>
                </button>
              <% end %>
            </div>
          </div>
        </div>
      </.focus_wrap>
    </div>
    """
  end
end
