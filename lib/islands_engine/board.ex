defmodule IslandsEngine.Board do
  alias IslandsEngine.Island
  def new(), do: %{}

  def position_island(board, key, %Island{} = island) do
    case overlaps_existing_island?(board, key, island) do
      false -> {:ok, Map.put(board, key, island)}
      true -> {:error, :overlapping_island}
    end
  end

  defp overlaps_existing_island?(board, new_key, new_island) do
    Enum.any?(board, fn {key, island} ->
      key != new_key and Island.overlaps?(island, new_island)
    end)
  end
end
