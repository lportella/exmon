defmodule ExMonTest do
  alias ExMon.Player

  import ExUnit.CaptureIO

  use ExUnit.Case

  describe "create_player/4" do
    test "returns a player" do
      expected_response = %Player{
        name: "TestName",
        life: 100,
        moves: %{move_heal: :heal, move_avg: :kick, move_rnd: :punch}
      }
      assert ExMon.create_player("TestName", :kick, :punch, :heal) == expected_response
    end
  end

  describe "start_game/1" do
    test "when the game starts, returns a message" do
      player = Player.build("TestPlayer", :kick, :punch, :heal)

      messages =
        capture_io(fn ->
          assert %{status: :started} = ExMon.start_game(player)
        end)

      assert messages =~ "The game has started"
    end
  end

  describe "make_move/1" do
    setup do
      player = Player.build("TestPlayer", :kick, :punch, :heal)

      capture_io(fn ->
        ExMon.start_game(player)
      end)

      :ok
    end

    test "when the move is valid, player makes a move and the computer makes a move" do
      messages =
        capture_io(fn ->
          ExMon.make_move(:kick)
        end)

      assert messages =~ "The player has attacked the computer"
      assert messages =~ "It‘s computer turn"
      assert messages =~ "status: :continue"
    end

    test "when the move is invalid, returns an error message" do
      messages =
        capture_io(fn ->
          ExMon.make_move(:invalid)
        end)

      assert messages =~ "Invalid move: invalid"
    end
  end
end
