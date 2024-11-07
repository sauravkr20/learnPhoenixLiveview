defmodule Plax.Chat do
  alias Plax.Chat.Message
  alias Plax.Chat.Room
  alias Plax.Repo
  alias Plax.Accounts.User

  import Ecto.Query

  def get_first_room! do
    # [room | _] = list_rooms()
    # room

    Repo.one!(from r in Room, limit: 1, order_by: [asc: :name])
  end

  def get_room!(id) do
    Repo.get!(Room, id)
  end

  def list_rooms do
    # Room |> Repo.all()
    Repo.all(from r in Room, order_by: [asc: :name])
  end

  def create_room(attrs) do
    %Room{}
      |> Room.changeset(attrs)
      |> Repo.insert()
  end

  def update_room(%Room{}= room, attrs) do
    room
      |> Room.changeset(attrs)
      |> Repo.update()
  end

  def change_room(room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end

  def list_all_messages_in_room(%Room{id: room_id})do
    Message
      |> where([m], m.room_id == ^room_id)
      |> order_by(asc: :inserted_at)
      |> preload(:user)
      |> Repo.all()
  end

  def change_message(message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  def create_message(room , attrs, user) do
    %Message{room: room, user: user}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def delete_message_by_id(id, %User{id: user_id})do
    message = %Message{user_id: ^user_id} = Repo.get(Message,id)

    Repo.delete(message)
  end
end
