defmodule ExMon.Game.Actions.Heal do
  alias ExMon.Game
  alias ExMon.Game.Status

  @heal_power 18..25

  def heal_life(player_key) do
    player_key
    |> Game.fetch_player()
    |> Map.get(:life)
    |> calculate_total_life()
    |> set_life(player_key)
  end

  defp calculate_total_life(life), do: Enum.random(@heal_power) + life
  defp set_life(life, player_key) when life > 100, do: update_player_life(player_key, 100)
  defp set_life(life, player_key), do: update_player_life(player_key, life)

  defp update_player_life(player_key, life) do
    player_key
    |> Game.fetch_player()
    |> Map.put(:life, life)
    |> update_game(player_key, life)
  end

  defp update_game(new_player_state, player_key, life) do
    Game.info()
    |> Map.put(player_key, new_player_state)
    |> Game.update()
    Status.print_heal_message(player_key, :heal, life)
  end
end
