defmodule A2048.Board do
  use GenServer


  ## Client API

  @doc """
  Starts the Board process.
  """
  def create do
    GenServer.start_link(__MODULE__, :ok)
  end

  @doc """
  Ensures there is a board associated to the given `name` in `server`.
  """
  def print(server) do
    GenServer.call(server, :print)
    |> print_board
  end


  @doc """
  Performs a transition

  TODO: 
  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def transition(server, direction) do
    GenServer.call(server, {:transition, direction})
  end

  ## Server Callbacks
  def init(:ok) do
    {:ok, new_board}
  end

  # TODO
  def handle_call(:print, _from, board) do
    {:reply, board, board}
  end

  ## Private

  defp print_board(board) do
    board
    |> Enum.each(&print_column/1)
  end

  defp print_column(column) do
    column |> Enum.each(&print_cell/1)
    IO.puts("")
  end

  defp print_cell(cell) do
    IO.write " [#{cell}] "
  end

  # Creates an empty board with 2 randomized slots.
  defp new_board do
    empty_board
    |> randomize_position
    |> randomize_position
  end

  # Introduces a random value in any
  # available slot in the board.
  defp randomize_position(board) do
    position = :rand.uniform(3)
    column = Enum.at(board, position)
             |> replace_random_empty_cell
    List.replace_at(board, position, column)
  end

  # Replace a random empty (0) value with a
  # random value (2/4) in the supplied column.
  #
  # Will return:
  #
  # - The same column if no available slots
  # - A new column with a random empty slot replaced with either 2 or 4
  defp replace_random_empty_cell(column) do
    position = random_column_position
    available_slots = Enum.any?(column, &(&1 == 0))
    case Enum.at(column, position) do
      0 -> List.replace_at(column, position, random_value)
      _ when available_slots -> replace_random_empty_cell(column)
      _ when not available_slots -> column
    end
  end

  # Returns a random number between 0 and 3
  defp random_column_position do
    :rand.uniform(3)
  end

  # Returns either 2 or 4 (randomly)
  defp random_value do
    Enum.at([2,4], :rand.uniform(2) - 1)
  end

  # Returns a board (4 x 4) with empty slots
  defp empty_board do
    List.duplicate([0,0,0,0], 4)
  end
end
