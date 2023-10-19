defmodule MementoWeb.Router do
  use MementoWeb, :router
  use AshAuthentication.Phoenix.Router
  import Phoenix.LiveDashboard.Router
  import AshAdmin.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MementoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
  end

  scope "/", MementoWeb do
    pipe_through :browser

    get "/", PageController, :home

    sign_in_route(register_path: "/register", reset_path: "/reset")
    sign_out_route AuthController
    auth_routes_for Memento.Accounts.User, to: AuthController
    reset_route []

    live_dashboard "/dashboard"
  end

  scope "/" do
    # Pipe it through your browser pipeline
    pipe_through [:browser]

    ash_admin("/admin")
  end

  # Other scopes may use custom stacks.
  # scope "/api", MementoWeb do
  #   pipe_through :api
  # end

  ash_authentication_live_session :authentication_required,
    on_mount: {MementoWeb.LiveUserAuth, :live_user_required} do
    # live "/mementos", MementoLive.Index, :index
    # live "/mementos/new", MementoLive.Index, :new
    # live "/mementos/:id/edit", MementoLive.Index, :edit

    # live "/mementos/:id", MementoLive.Show, :show
    # live "/mementos/:id/show/edit", MementoLive.Show, :edit
  end

  ash_authentication_live_session :authentication_optional,
    on_mount: {MementoWeb.LiveUserAuth, :live_user_optional} do
    live "/", MementoWeb.DashboardLive
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:memento, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    # import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      # live_dashboard "/dashboard", metrics: MementoWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
