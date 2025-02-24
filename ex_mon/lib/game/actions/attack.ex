defmodule ExMon.Game.Actions.Attack do
  alias ExMon.Game
  alias ExMon.Game.Status

  @move_avg_power 18..25
  @move_rnd_power 18..25

  def attack_opponent(playerKey, move) do
    damage = calculate_power(move)
    playerKey
    |> Game.fetch_player()
    |> Map.get(:life)
    |> calculate_total_life(damage)
    |> update_player_life(playerKey, damage)
  end

  defp update_player_life(life, playerKey, damage) do
    playerKey
    |> Game.fetch_player()
    |> Map.put(:life, life)
    |> update_game(playerKey, damage)
  end

  defp update_game(newPlayerState, playerKey, damage) do
    Game.info()
    |> Map.put(playerKey, newPlayerState)
    |> Game.update()

    Status.print_move_message(playerKey, :attack, damage)
  end

  defp calculate_power(:move_avg), do: Enum.random(@move_avg_power)
  defp calculate_power(:move_rnd), do: Enum.random(@move_rnd_power)
  defp calculate_total_life(life, damage) when life - damage < 0, do: 0
  defp calculate_total_life(life, damage), do: life - damage
end
