defmodule ExMon.Game.Status do
  alias ExMon.Game
  def print_round_message() do
    IO.puts("\nThe game has started.\n")
    IO.inspect(Game.info)
  end

  def print_wrong_move_message(move) do
    IO.puts("\nInvalid move: #{move}.\n")
  end
end
