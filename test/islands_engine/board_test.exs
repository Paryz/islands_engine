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
    {:ok, board} = Board.new() |> Board.position_island(:dot, dot_island)

    assert Board.position_island(board, :square, square_island) ==
             {:error, :overlapping_island}
  end

  test "islands are not overlapping" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, coordinate_2} = Coordinate.new(1, 2)

    {:ok, dot_island} = Island.new(:dot, coordinate_1)
    {:ok, square_island} = Island.new(:square, coordinate_2)
    {:ok, board} = Board.new() |> Board.position_island(:dot, dot_island)

    assert {:ok, %{dot: ^dot_island, square: ^square_island}} =
             Board.position_island(board, :square, square_island)
  end
end
