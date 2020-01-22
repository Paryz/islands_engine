defmodule IslandsEngine.Guesses do
  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  def new(), do: %__MODULE__{hits: MapSet.new(), misses: MapSet.new()}
end