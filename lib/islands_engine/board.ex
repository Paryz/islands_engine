defmodule IslandsEngine.Board do
  alias IslandsEngine.Island
  def new(), do: %{}

  def position_island(board, key, %Island{} = island) do
    case overlaps_existing_island?(board, key, island) do
      false -> Map.put(board, key, island)
      true -> {:error, :overlapping_island}
    end
  end

  def all_islands_positioned?(board) do
    Enum.all?(Island.types(), &Map.has_key?(board, &1))
  end

  def guess(board, coordinate) do
    {:miss, :none, :no_win, board}
  end

  defp overlaps_existing_island?(board, new_key, new_island) do
    Enum.any?(board, fn {key, island} ->
      key != new_key and Island.overlaps?(island, new_island)
    end)
  end
end
