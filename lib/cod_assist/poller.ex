defmodule CodAssist.Poller do
  use GenServer
  alias CodAssist.Notifier
  require Logger

  @milliseconds_to_sleep 20_000
  @seconds_of_server_not_up_before_notification 35

  @socket_port_no 8990
  @server_port_no 28960
  @broadcast_ip {255, 255, 255, 255}

  def start_link(opts \\ []) do
    {:ok, pid} = GenServer.start_link(__MODULE__, :ok, opts)
    Task.async(fn -> loop_broadcast_getinfo(pid) end)
    {:ok, pid}
  end

  def loop_broadcast_getinfo(server) do
    GenServer.cast(server, {:broadcast_getinfo, nil})
    :timer.sleep(@milliseconds_to_sleep)
    loop_broadcast_getinfo(server)
  end

  def init(:ok) do
    Logger.info "Call of Duty 2/4 server notifier started."
    {:ok, socket} = :gen_udp.open(@socket_port_no, [broadcast: true])
    {:ok, %{socket: socket, last_seen_up: 0}}
  end

  def handle_cast({:broadcast_getinfo, _}, %{socket: socket} = state) do
    :gen_udp.send(socket, @broadcast_ip, @server_port_no, [255,255,255,255] ++ 'getinfo')
    {:noreply, state}
  end

  def handle_info({:udp, _socket, ip, port_no, data}, %{last_seen_up: last_seen_up} = state) do
    if now - last_seen_up >= @seconds_of_server_not_up_before_notification do
      handle_info_received(ip, port_no, data)
    end
    {:noreply, %{state | :last_seen_up => now()}}
  end
  def handle_info_received(ip, port_no, data) do
    [_,_,_,_|msg] = data # we don't need the first four chars
    protocol_no = Notifier.info_response_keywords(msg) |> Keyword.get(:protocol) |> String.to_integer
    Notifier.announce_game_for_protocol_no(protocol_no, ip, port_no, msg)
  end

  defp now do
    :erlang.universaltime |> :calendar.datetime_to_gregorian_seconds
  end
end
