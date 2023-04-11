defmodule LiveSupWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use LiveSupWeb, :controller
      use LiveSupWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def controller do
    quote do
      use Phoenix.Controller, namespace: LiveSupWeb

      import Plug.Conn
      import LiveSupWeb.Gettext
      alias LiveSupWeb.Router.Helpers, as: Routes

      action_fallback(LiveSupWeb.FallbackController)

      unquote(verified_routes())
    end
  end

  def api_controller do
    quote do
      use Phoenix.Controller, namespace: LiveSupWeb

      import Plug.Conn
      import LiveSupWeb.Gettext
      alias LiveSupWeb.Router.Helpers, as: Routes

      action_fallback(LiveSupWeb.Api.FallbackController)
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/live_sup_web/templates",
        pattern: "**/*",
        # container: {:div, class: "flex h-screen antialiased text-gray-900 bg-gray-100 dark:bg-dark dark:text-light"},
        namespace: LiveSupWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {LiveSupWeb.LayoutView, :live},
        container: {:main, class: "main-content w-full px-[var(--margin-x)] pb-8"}

      import Logger

      import LiveSupWeb.Live.AuthHelper

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import LiveSupWeb.Gettext
    end
  end

  def component do
    quote do
      use Phoenix.Component

      unquote(view_helpers())
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers
      import Phoenix.Component

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import LiveSupWeb.ErrorHelpers
      import LiveSupWeb.Gettext
      alias LiveSupWeb.Router.Helpers, as: Routes

      use Palette

      # Custom helpers
      import LiveSupWeb.Helpers
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: LiveSupWeb.Endpoint,
        router: LiveSupWeb.Router,
        statics: LiveSupWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
