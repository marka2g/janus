defmodule Janus.SubscribersTest do
  use Janus.DataCase

  alias Janus.Subscribers

  describe "users" do
    alias Janus.Subscribers.User

    @valid_attrs %{
      email: "some email", 
      is_active: true, 
      password: "some password", 
      type: "Subscriber"
    }
    @update_attrs %{
      email: "some updated email", 
      is_active: false, 
      password: "some updated password"
    }
    @invalid_attrs %{
      email: nil, 
      is_active: nil, 
      password: nil, 
      type: nil
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Subscribers.create_user()

      user
    end

    def user_without_password(attrs \\ %{}) do
      %{user_fixture(attrs) | password: nil}
    end

    test "list_users/0 returns all users" do
      user = user_without_password()
      assert Subscribers.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_without_password()
      assert Subscribers.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Subscribers.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.is_active == true
      assert user.password == "some password"
      assert Pbkdf2.verify_pass("some password", user.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Subscribers.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Subscribers.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.is_active == false
      assert user.password == "some updated password"
      assert Pbkdf2.verify_pass("some updated password", user.password_hash)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_without_password()
      assert {:error, %Ecto.Changeset{}} = Subscribers.update_user(user, @invalid_attrs)
      assert user == Subscribers.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Subscribers.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Subscribers.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Subscribers.change_user(user)
    end

    test "authenticate_user/2 authenticates the user" do
      user = user_without_password()
      assert {:error, "Wrong email or password"} = Subscribers.authenticate_user("wrong email", "")
      assert {:ok, authenticated_user} = Subscribers.authenticate_user(user.email, @valid_attrs.password)
      assert user == authenticated_user
    end
  end
end
