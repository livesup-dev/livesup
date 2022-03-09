defmodule LiveSupWeb.Router do
  use LiveSupWeb, :router

  import LiveSupWeb.Auth.UserAuth
  import LiveSupWeb.Live.Auth.ProjectAuth
  import LiveSupWeb.LayoutHelper

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LiveSupWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_authenticated do
    plug LiveSupWeb.Plugs.AuthAccessPipeline
  end

  pipeline :mounted_apps do
    plug :accepts, ["html"]
    plug :put_secure_browser_headers
  end

  # scope "/", LiveSupWeb do
  #   pipe_through :browser

  #   live "/", PageLive, :index
  # end

  # Other scopes may use custom stacks.
  # scope "/api", LiveSupWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/admin/system-dashboard",
        metrics: LiveSupWeb.Telemetry,
        ecto_repos: [LiveSup.Repo]
    end
  end

  ## Authentication routes
  scope "/api", LiveSupWeb.Api, as: :api do
    pipe_through :api

    post "/sessions", SessionController, :create

    resources "/teams", TeamController
  end

  scope "/oauth", LiveSupWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/:provider", UserOauthController, :request
    get "/:provider/callback", UserOauthController, :callback
  end

  scope "/", LiveSupWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated, :put_session_layout]

    get "/users/register", Auth.UserRegistrationController, :new
    post "/users/register", Auth.UserRegistrationController, :create
    get "/users/log-in", Auth.UserSessionController, :new
    post "/users/log-in", Auth.UserSessionController, :create
    get "/users/reset-password", Auth.UserResetPasswordController, :new
    post "/users/reset-password", Auth.UserResetPasswordController, :create
    get "/users/reset-password/:token", Auth.UserResetPasswordController, :edit
    put "/users/reset-password/:token", Auth.UserResetPasswordController, :update
  end

  scope "/", LiveSupWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/", HomeController, :index
    # get "/projects", ProjectController, :index
    # get "/projects/:id", ProjectController, :show

    # live "/user-profile", HomeLive, :user

    get "/users/settings", UserSettingsController, :page
    # get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", LiveSupWeb do
    pipe_through [
      :browser,
      :require_authenticated_user,
      :ensure_access_to_project
    ]

    # get "/projects/:project_id/dashboards", DashboardController, :index
    # get "/dashboards/:dashboard_id", DashboardController, :show

    live "/projects", Project.ProjectLive, :index
    live "/projects/new", Project.ProjectLive, :new
    live "/projects/:id/dashboards", Project.DashboardLive, :index
    live "/projects/:id/dashboards/new", Project.DashboardLive, :new
    live "/dashboards/:id", Project.DashboardLive, :show
    live "/dashboards/:id/widgets", Dashboard.WidgetLive, :show
    live "/dashboards/:dashboard_id/widgets/:id", Dashboard.WidgetLive, :add
    live "/projects/:project_id/datasources", Project.DatasourceLive, :index
    live "/projects/:project_id/datasources/:id/edit", Project.DatasourceLive, :edit

    live "/teams/new", Teams.TeamListLive, :new
    live "/teams", Teams.TeamListLive, :index
    live "/teams/:id", Teams.TeamListLive, :show
    live "/teams/:id/edit", Teams.TeamListLive, :edit
    live "/teams/:id/members", Teams.MembersLive, :index
    live "/teams/:id/members/add", Teams.MembersLive, :add
    # get "/projects/:id/datasources", DatasourceController, :index
  end

  scope "/", LiveSupWeb do
    pipe_through [:browser, :require_authenticated_user, :put_setup_layout]

    live "/setup", SetupLive.Index, :index
    live "/setup/projects/:id", SetupLive.Index, :project
  end

  scope "/", LiveSupWeb do
    pipe_through [:browser]

    delete "/users/log_out", Auth.UserSessionController, :delete
    get "/users/confirm", Auth.UserConfirmationController, :new
    post "/users/confirm", Auth.UserConfirmationController, :create
    get "/users/confirm/:token", Auth.UserConfirmationController, :confirm
  end

  scope "/admin", LiveSupWeb.Admin, as: :admin do
    pipe_through [:browser, :require_authenticated_user]

    live "/", HomeLive.Show, :show

    live "/projects", ProjectLive.Index, :index
    live "/projects/new", ProjectLive.Index, :new
    live "/projects/:id/edit", ProjectLive.Index, :edit
    live "/projects/:id", ProjectLive.Show, :show
    live "/projects/:id/show/edit", ProjectLive.Show, :edit

    live "/teams", TeamLive.Index, :index
    live "/teams/new", TeamLive.Index, :new
    live "/teams/:id/edit", TeamLive.Index, :edit
    live "/teams/:id", TeamLive.Show, :show
    live "/teams/:id/show/edit", TeamLive.Show, :edit
  end

  scope path: "/admin/feature-flags" do
    pipe_through :mounted_apps
    forward "/", FunWithFlags.UI.Router, namespace: "admin/feature-flags"
  end
end
