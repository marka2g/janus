defmodule JanusWeb.Router do
  use JanusWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  # protect a resource
  pipeline :api_authentication do
    plug :ensure_authenticated
  end

  scope "/api", JanusWeb do
    pipe_through :api
    # resources "/users", UserController, except: [:new, :edit]
    post "/users/sign_in", UserController, :sign_in
  end

  # protect a resource
  scope "/api", JanusWeb do
    pipe_through [:api, :api_authentication]
    resources "/users", UserController, except: [:new, :edit]
  end

  # Function Plug
  defp ensure_authenticated(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)
    if current_user_id do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(JanusWeb.ErrorView)
      |> render("401.json", message: "Unauthenticated user")
      |> halt()
    end
  end

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
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: JanusWeb.Telemetry, ecto_repos: [Janus.Repo]
    end
  end
end
