defmodule IslandsEngine.Islands do
  alias IslandsEngine.Coordinate
  @enforce_keys [:coordinates, :hit_coordinates]
  defstruct [:coordinates, :hit_coordinates]

  def new(), do: %__MODULE__{coordinates: MapSet.new(), hit_coordinates: MapSet.new()}
end
