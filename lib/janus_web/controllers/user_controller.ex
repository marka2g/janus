defmodule JanusWeb.UserController do
  use JanusWeb, :controller

  alias Janus.Subscribers
  alias Janus.Subscribers.User

  action_fallback JanusWeb.FallbackController

  def index(conn, _params) do
    users = Subscribers.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Subscribers.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Subscribers.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Subscribers.get_user!(id)

    with {:ok, %User{} = user} <- Subscribers.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Subscribers.get_user!(id)

    with {:ok, %User{}} <- Subscribers.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  # note the modules `JanusWeb` not `Janus`
  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Janus.Subscribers.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        # it’s good practice to renew the session whenever you upgrade it from a guest state to an authenticated state. this helps to prevent a session fixation attack
        |> put_session(:current_user_id, user.id)
        |> configure_session(renew: true)
        |> put_status(:ok)
        |> put_view(JanusWeb.UserView)
        |> render("sign_in.json", user: user)
      {:error, message} ->
        conn
        |> delete_session(:current_user_id)
        |> put_status(:unauthorized)
        |> put_view(JanusWeb.ErrorView)
        |> render("401.json", message: message)
    end
  end
end
