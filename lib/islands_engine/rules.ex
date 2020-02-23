defmodule IslandsEngine.Rules do
  defstruct state: :initialized,
            player1: :islands_not_set,
            player2: :islands_not_set

  def new(), do: %__MODULE__{}

  def check(%__MODULE__{state: :initialized} = rules, :add_player) do
    {:ok, %__MODULE__{rules | state: :players_set}}
  end

  def check(%__MODULE__{state: :players_set} = rules, {:position_island, player}) do
    case Map.fetch!(rules, player) do
      :islands_set -> :error
      :islands_not_set -> {:ok, rules}
    end
  end

  def check(%__MODULE__{state: :players_set} = rules, {:set_islands, player}) do
    rules = Map.put(rules, player, :islands_set)

    case both_players_islands_set?(rules) do
      true -> {:ok, %__MODULE__{rules | state: :player1_turn}}
      false -> {:ok, rules}
    end
  end

  def check(%__MODULE__{state: :player1_turn} = rules, {:guess_coordinate, :player1}) do
    {:ok, %__MODULE__{rules | state: :player2_turn}}
  end

  def check(%__MODULE__{state: :player2_turn} = rules, {:guess_coordinate, :player2}) do
    {:ok, %__MODULE__{rules | state: :player1_turn}}
  end

  def check(%__MODULE__{state: :player1_turn} = rules, {:win_check, win_or_no_win}) do
    case win_or_no_win do
      :no_win -> {:ok, rules}
      :win -> {:ok, %__MODULE__{rules | state: :game_over}}
    end
  end

  def check(%__MODULE__{state: :player2_turn} = rules, {:win_check, win_or_no_win}) do
    case win_or_no_win do
      :no_win -> {:ok, rules}
      :win -> {:ok, %__MODULE__{rules | state: :game_over}}
    end
  end

  def check(_wrong_state, _wrong_action), do: :error

  defp both_players_islands_set?(rules) do
    rules.player1 == :islands_set && rules.player2 == :islands_set
  end
end
