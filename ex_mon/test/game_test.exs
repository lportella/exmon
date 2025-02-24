defmodule Exmon.GameTest do
  alias ExMon.Player
  alias ExMon.Game

  use ExUnit.Case

  describe "start/2" do
    test "starts the game state" do
      computer = Player.build("TestComputer", :kick, :punch, :heal)
      player = Player.build("TestPlayer", :kick, :punch, :heal)
      assert {:ok, _pid} = Game.start(computer, player)
    end
  end

  describe "info/0" do
    test "returns the current game state" do
      computer = Player.build("TestComputer", :kick, :punch, :heal)
      player = Player.build("TestPlayer", :kick, :punch, :heal)
      Game.start(computer, player)

      expected_response = %{
        status: :started,
        computer: %Player{
          life: 100,
          moves: %{move_heal: :heal, move_avg: :punch, move_rnd: :kick},
          name: "TestComputer"
          },
        player: %Player{
          life: 100,
          moves: %{move_heal: :heal, move_avg: :punch, move_rnd: :kick},
          name: "TestPlayer"
          },
        turn: :player
      }

      assert Game.info() == expected_response
    end
  end

  describe "update/1" do
    test "returns the updated game state" do
      computer = Player.build("TestComputer", :kick, :punch, :heal)
      player = Player.build("TestPlayer", :kick, :punch, :heal)
      Game.start(computer, player)

      expected_response = %{
        status: :started,
        computer: %Player{
          life: 100,
          moves: %{move_heal: :heal, move_avg: :punch, move_rnd: :kick},
          name: "TestComputer"
          },
        player: %Player{
          life: 100,
          moves: %{move_heal: :heal, move_avg: :punch, move_rnd: :kick},
          name: "TestPlayer"
          },
        turn: :player
      }

      assert Game.info() == expected_response

      new_state = %{
        status: :started,
        computer: %Player{
          life: 80,
          moves: %{move_heal: :heal, move_avg: :punch, move_rnd: :kick},
          name: "TestComputer"
          },
        player: %Player{
          life: 75,
          moves: %{move_heal: :heal, move_avg: :punch, move_rnd: :kick},
          name: "TestPlayer"
          },
        turn: :player
      }

      Game.update(new_state)
      expected_response = %{new_state | turn: :computer, status: :continue}

      assert Game.info() == expected_response
    end
  end

  describe "player/0" do
    test "returns the :player info" do
      computer = Player.build("TestComputer", :kick, :punch, :heal)
      player = Player.build("TestPlayer", :kick, :punch, :heal)
      Game.start(computer, player)

      expected_response = %Player{
        life: 100,
        moves: %{move_heal: :heal, move_avg: :punch, move_rnd: :kick},
        name: "TestPlayer"
      }

      assert Game.player() == expected_response
    end
  end

  describe "turn/0" do
    test "returns the player for the current turn" do
      computer = Player.build("TestComputer", :kick, :punch, :heal)
      player = Player.build("TestPlayer", :kick, :punch, :heal)
      Game.start(computer, player)

      # when the game starts the :player is the first to play
      assert Game.turn() == :player
    end
  end

  describe "fetch_player/1" do
    test "returns the player info" do
      computer = Player.build("TestComputer", :kick, :punch, :heal)
      player = Player.build("TestPlayer", :kick, :punch, :heal)
      Game.start(computer, player)

      expected_response = %Player{
        life: 100,
        moves: %{move_heal: :heal, move_avg: :punch, move_rnd: :kick},
        name: "TestComputer"
      }

      assert Game.fetch_player(:computer) == expected_response
    end
  end
end
