# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Janus.Repo.insert!(%Janus.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
IO.puts("Adding a couple subscribers")

for user <- ~w(user1 user2 user3 user4) do
  Janus.Subscribers.create_user(%{email: "#{user}@asd.com", password: String.reverse(user)})
end

# delete the first user
# deleted_user = Janus.Subscribers.list_users |> Enum.at(0) |> Janus.Subscribers.delete_user
