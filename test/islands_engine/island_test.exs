defmodule IslandsEngine.IslandTest do
  use ExUnit.Case
  alias IslandsEngine.{Coordinate, Island}

  test "wrong island type" do
    {:ok, coordinate} = Coordinate.new(1, 1)

    assert {:error, :invalid_island_type} == Island.new(:wrong_type, coordinate)
  end

  test "island out of bound" do
    {:ok, coordinate_1} = Coordinate.new(1, 10)
    {:ok, coordinate_2} = Coordinate.new(2, 10)
    {:ok, coordinate_3} = Coordinate.new(3, 10)
    {:ok, coordinate_4} = Coordinate.new(4, 10)
    {:ok, coordinate_5} = Coordinate.new(5, 10)
    {:ok, coordinate_6} = Coordinate.new(6, 10)
    {:ok, coordinate_7} = Coordinate.new(7, 10)
    {:ok, coordinate_8} = Coordinate.new(8, 10)
    {:ok, coordinate_9} = Coordinate.new(9, 10)
    {:ok, coordinate_10} = Coordinate.new(10, 10)
    {:ok, coordinate_11} = Coordinate.new(10, 1)
    {:ok, coordinate_12} = Coordinate.new(10, 2)
    {:ok, coordinate_13} = Coordinate.new(10, 3)
    {:ok, coordinate_14} = Coordinate.new(10, 4)
    {:ok, coordinate_15} = Coordinate.new(10, 5)
    {:ok, coordinate_16} = Coordinate.new(10, 6)
    {:ok, coordinate_17} = Coordinate.new(10, 7)
    {:ok, coordinate_18} = Coordinate.new(10, 8)
    {:ok, coordinate_19} = Coordinate.new(10, 9)

    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_1)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_2)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_3)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_4)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_5)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_6)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_7)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_8)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_9)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_10)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_11)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_12)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_13)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_14)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_15)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_16)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_17)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_18)
    assert {:error, :invalid_coordinate} == Island.new(:square, coordinate_19)
  end

  test "creates a dot island" do
    {:ok, coordinate} = Coordinate.new(1, 1)
    mapset = MapSet.new() |> MapSet.put(coordinate)

    assert {:ok,
            %Island{
              coordinates: ^mapset,
              hit_coordinates: %MapSet{}
            }} = Island.new(:dot, coordinate)
  end

  test "creates a square island" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, coordinate_2} = Coordinate.new(1, 2)
    {:ok, coordinate_3} = Coordinate.new(2, 1)
    {:ok, coordinate_4} = Coordinate.new(2, 2)

    mapset =
      MapSet.new()
      |> MapSet.put(coordinate_1)
      |> MapSet.put(coordinate_2)
      |> MapSet.put(coordinate_3)
      |> MapSet.put(coordinate_4)

    assert {:ok,
            %Island{
              coordinates: ^mapset,
              hit_coordinates: %MapSet{}
            }} = Island.new(:square, coordinate_1)
  end

  test "creates a atoll island" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, coordinate_2} = Coordinate.new(1, 2)
    {:ok, coordinate_3} = Coordinate.new(2, 2)
    {:ok, coordinate_4} = Coordinate.new(3, 1)
    {:ok, coordinate_5} = Coordinate.new(3, 2)

    mapset =
      MapSet.new()
      |> MapSet.put(coordinate_1)
      |> MapSet.put(coordinate_2)
      |> MapSet.put(coordinate_3)
      |> MapSet.put(coordinate_4)
      |> MapSet.put(coordinate_5)

    assert {:ok,
            %Island{
              coordinates: ^mapset,
              hit_coordinates: %MapSet{}
            }} = Island.new(:atoll, coordinate_1)
  end

  test "creates a l shaped island" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, coordinate_2} = Coordinate.new(2, 1)
    {:ok, coordinate_3} = Coordinate.new(3, 1)
    {:ok, coordinate_4} = Coordinate.new(3, 2)

    mapset =
      MapSet.new()
      |> MapSet.put(coordinate_1)
      |> MapSet.put(coordinate_2)
      |> MapSet.put(coordinate_3)
      |> MapSet.put(coordinate_4)

    assert {:ok,
            %Island{
              coordinates: ^mapset,
              hit_coordinates: %MapSet{}
            }} = Island.new(:l_shape, coordinate_1)
  end

  test "creates a s shaped island" do
    {:ok, upper_left} = Coordinate.new(1, 1)
    {:ok, coordinate_1} = Coordinate.new(1, 2)
    {:ok, coordinate_2} = Coordinate.new(1, 3)
    {:ok, coordinate_3} = Coordinate.new(2, 1)
    {:ok, coordinate_4} = Coordinate.new(2, 2)

    mapset =
      MapSet.new()
      |> MapSet.put(coordinate_1)
      |> MapSet.put(coordinate_2)
      |> MapSet.put(coordinate_3)
      |> MapSet.put(coordinate_4)

    assert {:ok,
            %Island{
              coordinates: ^mapset,
              hit_coordinates: %MapSet{}
            }} = Island.new(:s_shape, upper_left)
  end

  test "islands are not overlapping" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, coordinate_2} = Coordinate.new(2, 2)

    {:ok, dot_island} = Island.new(:dot, coordinate_1)
    {:ok, square_island} = Island.new(:square, coordinate_2)

    assert Island.overlaps?(dot_island, square_island) == false
  end

  test "islands are overlapping" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)

    {:ok, dot_island} = Island.new(:dot, coordinate_1)
    {:ok, square_island} = Island.new(:square, coordinate_1)

    assert Island.overlaps?(dot_island, square_island) == true
  end

  test "guess is missed" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, coordinate_2} = Coordinate.new(1, 2)
    {:ok, island} = Island.new(:dot, coordinate_1)

    assert Island.guess(island, coordinate_2) == :miss
  end

  test "guess is hit" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, island} = Island.new(:dot, coordinate_1)
    mapset = MapSet.put(island.hit_coordinates, coordinate_1)

    assert {:hit, %Island{hit_coordinates: ^mapset, coordinates: %MapSet{}}} =
             Island.guess(island, coordinate_1)
  end

  test "island is not forested" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, island} = Island.new(:square, coordinate_1)
    {:hit, island} = Island.guess(island, coordinate_1)

    assert Island.forested?(island) == false
  end

  test "island is forested" do
    {:ok, coordinate_1} = Coordinate.new(1, 1)
    {:ok, coordinate_2} = Coordinate.new(1, 2)
    {:ok, coordinate_3} = Coordinate.new(2, 1)
    {:ok, coordinate_4} = Coordinate.new(2, 2)
    {:ok, island} = Island.new(:square, coordinate_1)
    {:hit, island} = Island.guess(island, coordinate_1)
    {:hit, island} = Island.guess(island, coordinate_2)
    {:hit, island} = Island.guess(island, coordinate_3)
    {:hit, island} = Island.guess(island, coordinate_4)

    assert Island.forested?(island) == true
  end

  test "check all island types" do
    assert Island.types() == [:atoll, :dot, :l_shape, :s_shape, :square]
  end
end
