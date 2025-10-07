# gameboard for connect4
class Board
  attr_reader :rows, :columns

  def initialize(rows = 6, columns = 7)
    @my_board = Array.new(rows) { Array.new(columns, " ") }
    @rows = rows
    @columns = columns
  end

  def make_move(column, symbol)
    @rows.times do |i|
      if @my_board.dig(i, column) && @my_board[i][column].strip.empty?
        @my_board[i][column] = symbol
        return [i, column]
      end
    end

    nil
  end

  def clear_board
    @my_board.map! { |ele| ele.fill(" ") }
  end

  def board
    @my_board.map(&:itself)
  end
end
