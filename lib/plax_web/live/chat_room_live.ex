defmodule PlaxWeb.ChatRoomLive do
  use PlaxWeb, :live_view

  alias Plax.Chat.Room
  alias Plax.Repo

  def render(assigns) do
    ~H"""
      <div class="flex flex-col flex-grow shadow-lg">
        <div class="flex justify-between items-center flex-shrink-0 h-16 bg-white border-b border-slate-300 px-4">
          <div class="flex flex-col gap-1.5">
            <h1 class="text-sm font-bold leading-none">
              <%= @room.name%>
            </h1>
            <div class="text-xs leading-none h-3.5" phx-click="toggle-topic">
              <%= if @hide_topic? do %>
                <span class="text-slate-600">[Topic-hidden]</span>
              <% else %>
                <%= @room.topic %>
              <% end %>
             </div>
          </div>
        </div>
      </div>
    """
  end

  def mount(_params, _session, socket) do
    room = Room |> Repo.all() |> List.first()
    {:ok, assign(socket, hide_topic?: false, room: room)}
  end

  def handle_event("toggle-topic", _, socket) do
    {:noreply, assign(socket, hide_topic?: !socket.assigns.hide_topic?)}
  end
end
