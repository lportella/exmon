defmodule ExMon.Game.Actions.Attack do
  alias ExMon.Game
  alias ExMon.Game.Status

  @move_avg_power 18..25
  @move_rnd_power 18..25

  def attack_opponent(player_key, move) do
    damage = calculate_power(move)
    player_key
    |> Game.fetch_player()
    |> Map.get(:life)
    |> calculate_total_life(damage)
    |> update_player_life(player_key, damage)
  end

  defp update_player_life(life, player_key, damage) do
    player_key
    |> Game.fetch_player()
    |> Map.put(:life, life)
    |> update_game(player_key, damage)
  end

  defp update_game(new_player_state, player_key, damage) do
    Game.info()
    |> Map.put(player_key, new_player_state)
    |> Game.update()

    Status.print_move_message(player_key, :attack, damage)
  end

  defp calculate_power(:move_avg), do: Enum.random(@move_avg_power)
  defp calculate_power(:move_rnd), do: Enum.random(@move_rnd_power)
  defp calculate_total_life(life, damage) when life - damage < 0, do: 0
  defp calculate_total_life(life, damage), do: life - damage
end
