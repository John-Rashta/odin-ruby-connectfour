module WinCheck
  def vertical_win?(column, symbol, board)
    streak = 0
    board.rows.times do |i|
      if board[i][column] == symbol
        streak += 1
      else
        streak = 0
      end

      return true if streak == 4
    end
    false
  end

  def horizontal_win?(row, symbol, board)
    streak = 0
    board.columns.times do |i|
      if board[row][i] == symbol
        streak += 1
      else
        streak = 0
      end

      return true if streak == 4
    end
    false
  end

  def diagonal_win?(location, symbol, board)
  end

  def check_diagonal?(location, symbol, shift, board)
  end

  def left_most(row, column, board)
  end

  def right_most(row, column, board)
  end
end
