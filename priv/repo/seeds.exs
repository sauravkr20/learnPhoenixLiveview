# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Plax.Repo.insert!(%Plax.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Plax.Accounts
alias Plax.Chat.Room
alias Plax.Chat.Message
alias Plax.Repo

names = [
  "saurav",
  "gaurav",
  "anshu",
  "siya"
]

pw = "TheFellowship"

for name <- names do
  email = (name |> String.downcase()) <> "@fellowship.me"
  Accounts.register_user(%{email: email, password: pw, password_confirmation: pw})
end

saurav = Accounts.get_user_by_email("saurav@fellowship.me")
gaurav = Accounts.get_user_by_email("gaurav@fellowship.me")
anshu = Accounts.get_user_by_email("anshu@fellowship.me")
siya = Accounts.get_user_by_email("siya@fellowship.me")

room = Repo.insert!(%Room{name: "council-of-siya", topic: "What to do with this ring?"})

for {user, message} <- [
  {saurav, "Strangers from distant lands, friends of old. You have been summoned here to answer the threat of Mordor. Middle-Earth stands upon the brink of destruction. None can escape it. You will unite or you will fall. Each race is bound to this fate–this one doom."},
  {gaurav, "Bring forth the Ring, Frodo."},
  {siya, "So it is true…"},
  {siya, "It is a gift. A gift to the foes of Mordor. Why not use this Ring? Long has my father, the Steward of Gondor, kept the forces of Mordor at bay. By the blood of our people are your lands kept safe! Give Gondor the weapon of the Enemy. Let us use it against him!"},
  {anshu, "You cannot wield it! None of us can. The One Ring answers to Sauron alone. It has no other master."},
  {gaurav, "And what would a ranger know of this matter?"}
] do
  Repo.insert!(%Message{user: user, room: room, body: message})
end

