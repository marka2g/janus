defmodule JanusWeb.UserView do
  use JanusWeb, :view
  alias JanusWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  # `password:` removed. don't send a password attrib inside the response
  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      is_active: user.is_active
    }
  end
end
