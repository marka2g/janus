defmodule Janus.SubscribersTest do
  use Janus.DataCase

  alias Janus.Subscribers

  describe "users" do
    alias Janus.Subscribers.User

    @valid_attrs %{email: "some email", is_active: true, password_hash: "some password_hash", type: "some type", wordpress_id: "some wordpress_id"}
    @update_attrs %{email: "some updated email", is_active: false, password_hash: "some updated password_hash", type: "some updated type", wordpress_id: "some updated wordpress_id"}
    @invalid_attrs %{email: nil, is_active: nil, password_hash: nil, type: nil, wordpress_id: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Subscribers.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Subscribers.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Subscribers.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Subscribers.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.is_active == true
      assert user.password_hash == "some password_hash"
      assert user.type == "some type"
      assert user.wordpress_id == "some wordpress_id"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Subscribers.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Subscribers.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.is_active == false
      assert user.password_hash == "some updated password_hash"
      assert user.type == "some updated type"
      assert user.wordpress_id == "some updated wordpress_id"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
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
  end
end
