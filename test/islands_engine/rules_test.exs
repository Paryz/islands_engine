defmodule IslandsEngine.RulesTest do
  use ExUnit.Case
  alias IslandsEngine.Rules

  test "creates a rules struct" do
    assert Rules.new() == %Rules{
             state: :initialized,
             player1: :islands_not_set,
             player2: :islands_not_set
           }
  end

  test "catchall_clause" do
    assert Rules.check(:wrong_state, :wrong_action) == :error
  end

  test "add player changes state" do
    assert Rules.check(%Rules{state: :initialized}, :add_player) ==
             {:ok, %Rules{state: :players_set}}
  end

  test "player can't position islands" do
    assert Rules.check(
             %Rules{state: :players_set, player1: :islands_set},
             {:position_island, :player1}
           ) == :error
  end

  test "player can position islands" do
    assert Rules.check(
             %Rules{state: :players_set, player1: :islands_not_set},
             {:position_island, :player1}
           ) == {:ok, %Rules{state: :players_set, player1: :islands_not_set}}
  end

  test "only player1 set islands" do
    assert Rules.check(
             %Rules{state: :players_set, player1: :islands_not_set, player2: :islands_not_set},
             {:set_islands, :player1}
           ) == {:ok, %Rules{state: :players_set, player1: :islands_set}}
  end

  test "both players set islands" do
    assert Rules.check(
             %Rules{state: :players_set, player1: :islands_not_set, player2: :islands_set},
             {:set_islands, :player1}
           ) == {:ok, %Rules{state: :player1_turn, player1: :islands_set, player2: :islands_set}}
  end

  test "player1 makes a guess" do
    assert Rules.check(%Rules{state: :player1_turn}, {:guess_coordinate, :player1}) ==
             {:ok, %Rules{state: :player2_turn}}
  end

  test "player2 makes a guess" do
    assert Rules.check(%Rules{state: :player2_turn}, {:guess_coordinate, :player2}) ==
             {:ok, %Rules{state: :player1_turn}}
  end

  test "player2 makes a guess on player1 turn" do
    assert Rules.check(%Rules{state: :player1_turn}, {:guess_coordinate, :player2}) ==
             :error
  end

  test "player1 does not win" do
    assert Rules.check(%Rules{state: :player1_turn}, {:win_check, :no_win}) ==
             {:ok, %Rules{state: :player1_turn}}
  end

  test "player1 wins" do
    assert Rules.check(%Rules{state: :player1_turn}, {:win_check, :win}) ==
             {:ok, %Rules{state: :game_over}}
  end

  test "player2 does not win" do
    assert Rules.check(%Rules{state: :player2_turn}, {:win_check, :no_win}) ==
             {:ok, %Rules{state: :player2_turn}}
  end

  test "player2 wins" do
    assert Rules.check(%Rules{state: :player2_turn}, {:win_check, :win}) ==
             {:ok, %Rules{state: :game_over}}
  end
end
