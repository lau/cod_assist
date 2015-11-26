defmodule CodAssist.Notifier do
  require Logger

  @appIconCOD2 "'/Applications/CoD2/Call\ of\ Duty\ 2\ Multiplayer.app/Contents/Resources/Game_mp.icns'"
  @appIconCOD4 "'/Applications/Call\ of\ Duty\ 4/Call\ of\ Duty\ 4\ Multiplayer.app/Contents/Resources/Game_mp.icns'"
  @cod2exec "/Applications/cod2_mp.sh"
  @cod4exec "/Applications/cod4_mp.sh"
  @sound_name "Glass"

  def announce_game_for_protocol_no(4, ip, port_no, msg) do
    pretty_ip = ip |> tuple_to_pretty_ip
    map_code_name = info_response_keywords(msg) |> Keyword.get(:mapname)
    map_name = map_code_name |> shell_safe |> pretty_map_name
    game_type = info_response_keywords(msg) |> Keyword.get(:gametype) |> shell_safe |> pretty_game_type
    client_count_text = info_response_keywords(msg) |> Keyword.get(:clients) |> to_int |> player_count_text
    Logger.debug "Received message from COD4 server. #{pretty_ip} on port #{port_no}: #{msg}"

    "terminal-notifier -group 'cod4' -message 'COD4 server #{pretty_ip} running #{game_type}. #{client_count_text} on #{map_name}' -sound #{@sound_name} -appIcon #{@appIconCOD4} -execute '#{@cod4exec} #{pretty_ip} #{port_no}'"
    |> execute_in_shell
  end
  def announce_game_for_protocol_no(118, ip, port_no, msg) do
    pretty_ip = ip |> tuple_to_pretty_ip
    map_name = info_response_keywords(msg) |> Keyword.get(:mapname) |> shell_safe
    game_type = info_response_keywords(msg) |> Keyword.get(:gametype) |> shell_safe |> pretty_game_type
    client_count_text = info_response_keywords(msg) |> Keyword.get(:clients) |> to_int |> player_count_text
    Logger.debug "Received message from COD2 server. #{pretty_ip} on port #{port_no}: #{msg}"

    "terminal-notifier -group 'cod2' -message 'A COD2 server is running #{game_type} on #{pretty_ip} with #{client_count_text} on the map #{map_name}' -sound #{@sound_name} -appIcon #{@appIconCOD2} -execute '#{@cod2exec} #{pretty_ip} #{port_no}'"
    |> execute_in_shell
  end

  defp execute_in_shell(string), do: string |>  String.to_char_list |> :os.cmd

  defp to_int(nil), do: 0
  defp to_int(string), do: string |> String.to_integer

  defp tuple_to_pretty_ip(tuple), do: tuple |> Tuple.to_list |> Enum.join(".")

  def info_response_keywords(getinfo_messsage) do
    getinfo_messsage
    |> List.to_string
    |> String.replace("infoResponse\n\\", "")
    |> String.replace("'", "")
    |> String.split("\\")
    |> Enum.chunk(2)
    |> Enum.map(&(List.to_tuple(&1)))
    |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
  end

  # Only allow alphanumeric chars, underscores, dashes. To avoid escaping
  # and doing dangerous things in shell
  defp shell_safe(string), do: string |> String.replace(~r/[^a-zA-Z-09_-]/,"")

  defp player_count_text(1), do: "1 player"
  defp player_count_text(count), do: "#{count} players"

  defp pretty_map_name("mp_carentan"),    do: "China Town"
  defp pretty_map_name("mp_citystreets"), do: "District"
  defp pretty_map_name("mp_convoy"),      do: "Ambush"
  defp pretty_map_name("mp_crash_snow"),  do: "Winter Crash"
  defp pretty_map_name("mp_cargoship"),   do: "Wet Work"
  defp pretty_map_name("mp_farm"),        do: "Downpour"
  defp pretty_map_name(codename), do: codename |> String.replace("mp_", "") |> String.capitalize

  defp pretty_game_type("dm"),     do: "free for all"
  defp pretty_game_type("war"),    do: "team deathmatch"
  defp pretty_game_type("koth"),   do: "headquarters"
  defp pretty_game_type("sd"),     do: "search & destroy"
  defp pretty_game_type("dom"),    do: "domination"
  defp pretty_game_type("sab"),    do: "sabotage"
  defp pretty_game_type(codename), do: codename
end
