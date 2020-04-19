defmodule IslandsEngine.Game do
  use GenServer
  alias IslandsEngine.{Board, Guesses, Rules, Coordinate, Island}

  @players [:player1, :player2]

  def init(name) do
    player1 = %{name: name, board: Board.new(), guesses: Guesses.new()}
    player2 = %{name: nil, board: Board.new(), guesses: Guesses.new()}
    {:ok, %{player1: player1, player2: player2, rules: Rules.new()}}
  end

  def start_link(name) when is_binary(name) do
    GenServer.start_link(__MODULE__, name, [])
  end

  def add_player(game_pid, name) when is_binary(name) do
    GenServer.call(game_pid, {:add_player, name})
  end

  def position_island(game_pid, player, key, row, col) when player in @players do
    GenServer.call(game_pid, {:position_island, player, key, row, col})
  end

  def set_islands(game_pid, player) when player in @players do
    GenServer.call(game_pid, {:set_islands, player})
  end

  def guess_coordinate(game_pid, player, row, col) when player in @players do
    GenServer.call(game_pid, {:guess_coordinate, player, row, col})
  end

  # API
  def handle_call({:add_player, name}, _from, game_state) do
    with {:ok, rules} <- Rules.check(game_state.rules, :add_player) do
      game_state
      |> update_player2_name(name)
      |> update_rules(rules)
      |> reply_success(:ok)
    else
      :error -> {:reply, :error, game_state}
    end
  end

  def handle_call({:position_island, player, key, row, col}, _from, game_state) do
    board = player_board(game_state, player)

    with {:ok, rules} <- Rules.check(game_state.rules, {:position_island, player}),
         {:ok, coordinate} <- Coordinate.new(row, col),
         {:ok, island} <- Island.new(key, coordinate),
         %{} = board <- Board.position_island(board, key, island) do
      game_state
      |> update_board(player, board)
      |> update_rules(rules)
      |> reply_success(:ok)
    else
      :error ->
        {:reply, :error, game_state}

      {:error, :invalid_coordinate} ->
        {:reply, {:error, :invalid_coordinate}, game_state}

      {:error, :invalid_island_type} ->
        {:reply, {:error, :invalid_island_type}, game_state}

      {:error, :overlapping_island} ->
        {:reply, {:error, :overlapping_island}, game_state}
    end
  end

  def handle_call({:set_islands, player}, _from, game_state) do
    board = player_board(game_state, player)

    with {:ok, rules} <- Rules.check(game_state.rules, {:set_islands, player}),
         true <- Board.all_islands_positioned?(board) do
      game_state
      |> update_rules(rules)
      |> reply_success({:ok, board})
    else
      :error -> {:reply, :error, game_state}
      false -> {:reply, {:error, :not_all_islands_positioned}, game_state}
    end
  end

  def handle_call({:guess_coordinate, player, row, col}, _from, game_state) do
    opponent_key = opponent(player)
    opponent_board = player_board(game_state, opponent_key)

    with {:ok, rules} <- Rules.check(game_state.rules, {:guess_coordinate, player}),
         {:ok, coordinate} <- Coordinate.new(row, col),
         {hit_or_miss, forested_island, win_status, opponent_board} <-
           Board.guess(opponent_board, coordinate),
         {:ok, rules} <- Rules.check(rules, {:win_check, win_status}) do
      game_state
      |> update_board(opponent_key, opponent_board)
      |> update_guesses(player, hit_or_miss, coordinate)
      |> update_rules(rules)
      |> reply_success({hit_or_miss, forested_island, win_status})
    else
      :error -> {:reply, :error, game_state}
      {:error, :invalid_coordinate} -> {:reply, {:error, :invalid_coordinate}, game_state}
    end
  end

  defp update_player2_name(game_state, name) do
    put_in(game_state.player2.name, name)
  end

  defp update_board(game_state, player, board) do
    Map.update!(game_state, player, fn player -> %{player | board: board} end)
  end

  defp update_rules(game_state, rules), do: %{game_state | rules: rules}

  defp update_guesses(game_state, player, hit_or_miss, coordinate) do
    update_in(game_state[player].guesses, fn guesses ->
      Guesses.add(guesses, hit_or_miss, coordinate)
    end)
  end

  defp reply_success(game_state, response), do: {:reply, response, game_state}

  defp player_board(game_state, player), do: Map.get(game_state, player).board

  defp opponent(:player1), do: :player2
  defp opponent(:player2), do: :player1
end
