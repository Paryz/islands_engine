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
    board
    |> check_all_islands(coordinate)
    |> guess_response(board)
  end

  defp check_all_islands(board, coordinate) do
    Enum.find_value(board, :miss, fn {key, value} ->
      case Island.guess(value, coordinate) do
        :miss -> false
        {:hit, island} -> {key, island}
      end
    end)
  end

  defp guess_response(:miss, board), do: {:miss, :none, :no_win, board}

  defp guess_response({key, island}, board) do
    board = %{board | key => island}
    {:hit, forested_check(key, island), win_check(board), board}
  end

  defp forested_check(key, island) do
    case Island.forested?(island) do
      false -> :none
      true -> key
    end
  end

  defp win_check(board) do
    case Enum.all?(board, fn {_key, value} -> Island.forested?(value) end) do
      false -> :no_win
      true -> :win
    end
  end

  defp overlaps_existing_island?(board, new_key, new_island) do
    Enum.any?(board, fn {key, island} ->
      key != new_key and Island.overlaps?(island, new_island)
    end)
  end
end
