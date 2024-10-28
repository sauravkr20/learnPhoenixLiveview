defmodule Plax.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plax.Accounts.User
  alias Plax.Chat.Room

  schema "messages" do
    field :body, :string
    # field :user_id, :id
    # field :room_id, :id
    belongs_to :room, Room, foreign_key: :room_id
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
