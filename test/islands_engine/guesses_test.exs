defmodule IslandsEngine.GuessesTest do
  use ExUnit.Case
  alias IslandsEngine.{Coordinate, Guesses}

  test "creates new guess strauct" do
    assert %Guesses{hits: %MapSet{}, misses: %MapSet{}} == Guesses.new()
  end

  test "add a hit to guesses" do
    {:ok, coordinate} = Coordinate.new(1, 1)
    guesses = Guesses.new()
    guesses = Guesses.add(guesses, :hit, coordinate)
    %Guesses{hits: hits, misses: %MapSet{}} = guesses
    assert hits == MapSet.new() |> MapSet.put(coordinate)
  end

  test "add a miss to guesses" do
    {:ok, coordinate} = Coordinate.new(1, 1)
    guesses = Guesses.new()
    guesses = Guesses.add(guesses, :miss, coordinate)
    %Guesses{hits: %MapSet{}, misses: misses} = guesses
    assert misses == MapSet.new() |> MapSet.put(coordinate)
  end
end
