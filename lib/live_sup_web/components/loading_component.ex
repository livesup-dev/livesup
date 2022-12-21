defmodule LiveSupWeb.Components.LoadingComponent do
  use LiveSupWeb, :component

  def render(assigns) do
    # TODO: This component will always be loaded hidden
    assigns =
      assigns
      |> Map.put(:loaded_class, "hidden")

    ~H"""
    <div class={"#{@loaded_class} fixed inset-0 z-50 flex items-center justify-center text-2xl font-semibold text-white bg-primary-darker"}>
      Loading.....
    </div>
    """
  end
end
