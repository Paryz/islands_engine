defmodule IslandsEngine.CoordinateTest do
  use ExUnit.Case
  alias IslandsEngine.Coordinate

  test "coodinates inside the board" do
    assert {:ok, %Coordinate{row: 1, col: 1}} == Coordinate.new(1, 1)
  end

  test "coodinates outside the board" do
    assert {:error, :invalid_coordinate} == Coordinate.new(11, 1)
    assert {:error, :invalid_coordinate} == Coordinate.new(10, 11)
  end

  test "coordinates with negative number" do
    assert {:error, :invalid_coordinate} == Coordinate.new(-1, 1)
    assert {:error, :invalid_coordinate} == Coordinate.new(1, -1)
  end
end
