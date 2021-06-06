defmodule Janus.Subscribers.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :is_active, :boolean, default: false
    field :password_hash, :string
    field :type, :string
    field :wordpress_id, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:type, :wordpress_id, :email, :password_hash, :is_active])
    |> validate_required([:type, :wordpress_id, :email, :password_hash, :is_active])
    |> unique_constraint(:email)
  end
end
