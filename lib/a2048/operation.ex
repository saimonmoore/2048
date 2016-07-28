defmodule A2048.Operation do

  @zeroes_left_shifted_re ~r(^[1-9]+0*$)
  @zeroes_right_shifted_re ~r(^0*[1-9]+$)

  @doc """
  Shifts all entries in a 4 x 4 matrix to the left according to the 2048 rules.

  Rules:

  - 0 values correspond to empty slots and are unmoved.
  - >0 values are added to next value if equal and:
       - an empty slot replaces it.
       - the next value is doubled.
  - >0 values are moved to the next value if it is empty.

  ## Examples

  iex> IO.puts "Shift left: no doubling"
  iex> board = [[0,0,2,0],[0,2,0,0],[2,4,0,0],[0,2,0,0]]
  iex> expected = [[2,0,0,0],[2,0,0,0],[2,4,0,0],[2,0,0,0]]
  iex> A2048.Operation.shift(:left, board) == expected
  iex> IO.puts "Shift left: with doubling"
  iex> board = [[2,0,2,0],[4,2,0,2],[2,4,4,8],[2,2,2,2]]
  iex> expected = [[4,0,0,0],[4,4,0,0],[2,8,8,0],[4,4,0,0]]
  iex> A2048.Operation.shift(:left, board) == expected

  """
  def shift(:left, board) do
    Enum.map(board, fn(row) ->
      shift_zeros_left(row) |> double_likes
    end)
  end
  # def shift(:right, board) do
  # end
  # def shift(:up, board) do
  # end
  # def shift(:down, board) do
  # end

  defp shift_zeros_left(row) do
    Regex.split(~r(0), Enum.join(row), trim: true)
    |> Enum.join
    |> String.pad_trailing(4,"0")
    |> String.graphemes
    |> Enum.map(&String.to_integer/1)
  end

  defp double_likes(row) do
    row
    |> Enum.chunk(2)
    |> Enum.map(&double_like_pairs/1)
    |> List.flatten
    |> shift_zeros_left
  end

  defp double_like_pairs([head|tail]) do
    cond do
      head == tail -> [head*2,0]
      true -> [head, tail]
    end
  end
end
