defmodule Plax.Chat do
  alias Plax.Chat.Room
  alias Plax.Repo

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
end
