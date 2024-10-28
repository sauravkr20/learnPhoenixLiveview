defmodule PlaxWeb.ChatRoomLive do
  use PlaxWeb, :live_view

  alias Plax.Chat
  alias Plax.Chat.{Message, Room}

  def render(assigns) do
    IO.puts("rendered")

    ~H"""
      <div class="flex flex-col flex-shrink-0 bg-slate-100">
        <div class="flex justify-between items-center flex-shrink-0 h-16 border-b border-slate-300 px-4">
          <div class="flex flex-col gap-1.5">
            <h1 class="text-lg font-bold text-gray-800">
              Slax
            </h1>
          </div>
        </div>
        <div class="mt-4 overflow-auto">
          <div class="flex items-center h-8 px-3 group">
            <span class="ml-2 leading-none font-medium text-sm"> Rooms</span>
          </div>
          <div id="rooms-list">
            <%!-- <.room_link :for={room <- @rooms} room={room} active={room.id == @room.id} /> --%>
            <%= for room <- @rooms do %>
              <%= room_link(%{room: room, active: room.id == @room.id}) %>
            <% end %>
          </div>
        </div>
      </div>
      <div class="flex flex-col flex-grow shadow-lg">
        <div class="flex justify-between items-center flex-shrink-0 h-16 bg-white border-b border-slate-300 px-4">
          <div class="flex flex-col gap-1.5">
            <h1 class="text-sm font-bold leading-none">
             #<%= @room.name%>
              <.link class="font-normal text-xs text-blue-600 hover:text-blue-700" navigate={~p"/rooms/#{@room.id}/edit"}>
                Edit
              </.link>
            </h1>
            <div class="text-xs leading-none h-3.5" phx-click="toggle-topic">
              <%= if @hide_topic? do %>
                <span class="text-slate-600">[Topic-hidden]</span>
              <% else %>
                <%= @room.topic %>
              <% end %>
             </div>
          </div>
          <ul class="relative z-10 flex items-center gap-4 px-4 sm:px-6 lg:px-8 justify-end">
            <%= if @current_user do %>
              <li class="text-[0.8125rem] leading-6 text-zinc-900">
                <%= username(@current_user) %>
              </li>
              <li>
                <.link
                  href={~p"/users/settings"}
                  class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
                >
                  Settings
                </.link>
              </li>
              <li>
                <.link
                  href={~p"/users/log_out"}
                  method="delete"
                  class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
                >
                  Log out
                </.link>
              </li>
            <% else %>
              <li>
                <.link
                  href={~p"/users/register"}
                  class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
                >
                  Register
                </.link>
              </li>
              <li>
                <.link
                  href={~p"/users/log_in"}
                  class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
                >
                  Log in
                </.link>
              </li>
            <% end %>
          </ul>
        </div>
        <div class="flex flex-col flex-grow overflow-auto">
          <.message :for={message <- @messages} message={message}/>
        </div>
      </div>
    """
  end

  attr :message, Message, required: true
  defp message(assigns) do
    ~H"""
    <div class="relative flex px-4 py-3">
      <div class="h-10 w-10 rounded flex-shrink=0 bg-slate-300"></div>
      <div class="ml-2">
        <div class="-mt-1">
          <.link class="text-sm font-semibold hover:underline">
            <span>User</span>
          </.link>
          <p class="text-sm"><%= @message.body %></p>
        </div>
      </div>
    </div>
    """
  end

  attr :active , :boolean, required: true
  attr :room, Room, required: true
  defp room_link(assigns) do
    ~H"""
      <.link patch={~p"/rooms/#{@room.id}"} class={["flex items-center h-8 px-3 group", (@active && "bg-slate-300") || "hover:bg-slate-300" ]}>
        <.icon name="hero-hashtag" class="h-4 w-4"/>
        <span class={["ml-2 leading-none", @active && "font-bold"]}>
          <%= @room.name %>
        </span>
      </.link>
    """
  end

  def mount(_params, _session, socket) do
    IO.puts("mounted")
    rooms = Chat.list_rooms()

    {:ok, assign(socket, hide_topic?: false, rooms: rooms)}
  end

  def handle_params(params, _session, socket) do
    IO.puts("handle_params #{inspect(params)} (connected #{connected?(socket)})")
    room = case Map.fetch(params, "id") do
      {:ok, id} -> Chat.get_room!(id)
      :error -> List.first(socket.assigns.rooms)
    end

    messages = Chat.list_all_messages_in_room(room)

    {:noreply,
     assign(socket,
       hide_topic?: false,
       messages: messages,
       page_title: "#" <> room.name,
       room: room
     )}
  end

  def handle_event("toggle-topic", _, socket) do
    # {:noreply, assign(socket, hide_topic?: !socket.assigns.hide_topic?)}
    {:noreply, update(socket, :hide_topic?, &(!&1))}
  end

  defp username(user) do
    user.email |> String.split("@") |> List.first() |> String.capitalize()
  end
end
