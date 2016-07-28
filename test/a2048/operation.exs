defmodule A2048.OperationTest do
  use ExUnit.Case
  doctest A2048.Operation

  describe "#shift(:left) when no doubling" do
    setup [:a_board_with_no_doubling]

    test "shifts all numbers to the left" do
      expected = [[2,0,0,0],[2,0,0,0],[2,4,0,0],[2,0,0,0]]
      assert A2048.Operation.shift(:left, context[:board]) == expected
    end
  end

  defp a_board_with_no_doubling do
    board = [[0,0,2,0],[0,2,0,0],[2,4,0,0],[0,2,0,0]]
    {board: board}
  end
end
