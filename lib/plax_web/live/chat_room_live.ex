defmodule PlaxWeb.ChatRoomLive do
  use PlaxWeb, :live_view

  def render(assigns) do
    ~H"""
      <div>Welcome to the Chat!</div>
      <%= "<div>Welcome to \n the chat!</div>" %>
      <%= raw "<div>Welcome \n to the chat!</div>" %>
    """
  end
end
