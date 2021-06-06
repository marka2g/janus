defmodule Janus.Subscribers.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :wordpress_id, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :type, :string
    field :is_active, :boolean, default: false

    # timestamps()
    # add support for microseconds at the app level
    # for this specific schema
    timestamps(type: :utc_datetime_usec)

  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:type, :email, :password, :is_active])
    |> validate_required([:type, :email, :password, :is_active])
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  # https://hexdocs.pm/pbkdf2_elixir/Pbkdf2.html#hash_pwd_salt/2
  defp put_password_hash(
    %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
  ) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  # Notice the call and definition of put_password_hash/1. when the changeset runs through this function, if the changeset happens to be valid and have a password key, it’ll hash it using Pbkdf2
  defp put_password_hash(changeset) do
    changeset
  end
end
