defmodule IslandsEngine.BoardTest do
  use ExUnit.Case
  alias IslandsEngine.{Coordinate, Island, Board}

  test "creates a board" do
    assert Board.new() == %{}
  end

  test "islands are overlapping" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)

    {:ok, dot_island} = Island.new(:dot, coordinate_1)
    {:ok, square_island} = Island.new(:square, coordinate_1)
    board = Board.new() |> Board.position_island(:dot, dot_island)

    assert Board.position_island(board, :square, square_island) ==
             {:error, :overlapping_island}
  end

  test "islands are not overlapping" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, coordinate_2} = Coordinate.new(1, 2)

    {:ok, dot_island} = Island.new(:dot, coordinate_1)
    {:ok, square_island} = Island.new(:square, coordinate_2)
    board = Board.new() |> Board.position_island(:dot, dot_island)

    assert %{dot: ^dot_island, square: ^square_island} =
             Board.position_island(board, :square, square_island)
  end

  test "one island is not enough to start the game" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, dot_island} = Island.new(:dot, coordinate_1)
    board = Board.new() |> Board.position_island(:dot, dot_island)
    assert false == Board.all_islands_positioned?(board)
  end

  test "two islands are not enough to start the game" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, coordinate_2} = Coordinate.new(1, 2)
    {:ok, dot_island} = Island.new(:dot, coordinate_1)
    {:ok, square_island} = Island.new(:square, coordinate_2)

    board =
      Board.new()
      |> Board.position_island(:dot, dot_island)
      |> Board.position_island(:square, square_island)

    assert false == Board.all_islands_positioned?(board)
  end

  test "three islands are not enough to start the game" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, coordinate_2} = Coordinate.new(1, 2)
    {:ok, coordinate_3} = Coordinate.new(1, 4)
    {:ok, dot_island} = Island.new(:dot, coordinate_1)
    {:ok, square_island} = Island.new(:square, coordinate_2)
    {:ok, atoll_island} = Island.new(:atoll, coordinate_3)

    board =
      Board.new()
      |> Board.position_island(:dot, dot_island)
      |> Board.position_island(:square, square_island)
      |> Board.position_island(:atoll, atoll_island)

    assert false == Board.all_islands_positioned?(board)
  end

  test "four islands are not enough to start the game" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, coordinate_2} = Coordinate.new(1, 2)
    {:ok, coordinate_3} = Coordinate.new(1, 4)
    {:ok, coordinate_4} = Coordinate.new(1, 6)
    {:ok, dot_island} = Island.new(:dot, coordinate_1)
    {:ok, square_island} = Island.new(:square, coordinate_2)
    {:ok, atoll_island} = Island.new(:atoll, coordinate_3)
    {:ok, l_shape_island} = Island.new(:l_shape, coordinate_4)

    board =
      Board.new()
      |> Board.position_island(:dot, dot_island)
      |> Board.position_island(:square, square_island)
      |> Board.position_island(:atoll, atoll_island)
      |> Board.position_island(:l_shape, l_shape_island)

    assert false == Board.all_islands_positioned?(board)
  end

  test "five islands are enough to start the game" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, coordinate_2} = Coordinate.new(1, 2)
    {:ok, coordinate_3} = Coordinate.new(1, 4)
    {:ok, coordinate_4} = Coordinate.new(1, 6)
    {:ok, coordinate_5} = Coordinate.new(3, 1)
    {:ok, dot_island} = Island.new(:dot, coordinate_1)
    {:ok, square_island} = Island.new(:square, coordinate_2)
    {:ok, atoll_island} = Island.new(:atoll, coordinate_3)
    {:ok, l_shape_island} = Island.new(:l_shape, coordinate_4)
    {:ok, s_shape_island} = Island.new(:s_shape, coordinate_5)

    board =
      Board.new()
      |> Board.position_island(:dot, dot_island)
      |> Board.position_island(:square, square_island)
      |> Board.position_island(:atoll, atoll_island)
      |> Board.position_island(:l_shape, l_shape_island)
      |> Board.position_island(:s_shape, s_shape_island)

    assert true == Board.all_islands_positioned?(board)
  end

  test "missed hit can't win nor forest the island" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, coordinate_2} = Coordinate.new(1, 3)

    {:ok, square_island} = Island.new(:square, coordinate_1)

    board =
      Board.new()
      |> Board.position_island(:square, square_island)

    assert {:miss, :none, :no_win, ^board} = Board.guess(board, coordinate_2)
  end

  test "hit without win and without forest" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, coordinate_2} = Coordinate.new(1, 2)

    {:ok, square_island} = Island.new(:square, coordinate_1)

    board =
      Board.new()
      |> Board.position_island(:square, square_island)

    assert {:hit, :none, :no_win, %{}} = Board.guess(board, coordinate_2)
  end

  test "hit without win and with forest" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, coordinate_2} = Coordinate.new(1, 2)
    {:ok, coordinate_3} = Coordinate.new(2, 1)
    {:ok, coordinate_4} = Coordinate.new(2, 2)
    {:ok, coordinate_5} = Coordinate.new(5, 2)

    {:ok, square_island} = Island.new(:square, coordinate_1)
    {:ok, dot_island} = Island.new(:dot, coordinate_5)

    board =
      Board.new()
      |> Board.position_island(:square, square_island)
      |> Board.position_island(:dot, dot_island)

    {:hit, :none, :no_win, board} = Board.guess(board, coordinate_1)
    {:hit, :none, :no_win, board} = Board.guess(board, coordinate_2)
    {:hit, :none, :no_win, board} = Board.guess(board, coordinate_3)

    assert {:hit, :square, :no_win, %{}} = Board.guess(board, coordinate_4)
  end

  test "hit with win and with forest" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, coordinate_2} = Coordinate.new(1, 2)
    {:ok, coordinate_3} = Coordinate.new(2, 1)
    {:ok, coordinate_4} = Coordinate.new(2, 2)

    {:ok, square_island} = Island.new(:square, coordinate_1)

    board =
      Board.new()
      |> Board.position_island(:square, square_island)

    {:hit, :none, :no_win, board} = Board.guess(board, coordinate_1)
    {:hit, :none, :no_win, board} = Board.guess(board, coordinate_2)
    {:hit, :none, :no_win, board} = Board.guess(board, coordinate_3)

    assert {:hit, :square, :win, %{}} = Board.guess(board, coordinate_4)
  end
end
