defmodule A2048.Board do

  ## Server Callbacks
  def init do
    {:ok, new_board}
  end

  defp new_board do
    empty_board
    |> randomize_position
    |> randomize_position
  end

  defp randomize_position(board) do
    position = :rand.uniform(3)
    column = Enum.at(board, position)
             |> List.replace_at(:rand.uniform(3), random_value)
    List.replace_at(board, position, column)
  end

  defp random_value do
    Enum.at([2,4], :rand.uniform(2) - 1)
  end

  defp empty_board do
    List.duplicate([0,0,0,0], 4)
  end
end
