defmodule LiveSupWeb.Live.Components.LoadingComponent do
  use LiveSupWeb, :live_component

  @impl true
  def render(assigns) do
    # TODO: This component will always be loaded hidden
    assigns =
      assigns
      |> assign_new(:loaded_class, fn -> "hidden" end)

    ~H"""
    <div class={"#{@loaded_class} fixed inset-0 z-50 flex items-center justify-center text-2xl font-semibold text-white bg-primary-darker"}>
      Loading.....
    </div>
    """
  end
end
