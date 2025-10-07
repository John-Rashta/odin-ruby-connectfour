# Module to check all possible wins
# left_most and right_most will check the top location of both lines
# check_diagonal will than run from those top location till them bottom
# until it finds 4 of the same in a row or reaches the end
module WinCheck
  def check_win?(location, symbol, board)
    return true if vertical_win?(location[1], symbol, board) ||
                   horizontal_win?(location[0], symbol, board) ||
                   diagonal_win?(location, symbol, board)

    false
  end

  def vertical_win?(column, symbol, board)
    streak = 0
    fake_board = board.board
    board.rows.times do |i|
      streak = fake_board[i][column] == symbol ? streak + 1 : 0
      return true if streak == 4
    end
    false
  end

  def horizontal_win?(row, symbol, board)
    streak = 0
    fake_board = board.board
    board.columns.times do |i|
      streak = fake_board[row][i] == symbol ? streak + 1 : 0
      return true if streak == 4
    end
    false
  end

  def diagonal_win?(location, symbol, board)
    left = left_most(location[0], location[1], board)
    right = right_most(location[0], location[1], board)
    return true if check_diagonal?(left, symbol, "left", board) || check_diagonal?(right, symbol, "right", board)

    false
  end

  def check_diagonal?(location, symbol, side, board)
    return false unless validate_diagonal_location?(location, side, board)

    shift = side == "left" ? 1 : -1
    streak = 0
    current_column = location[1]
    fake_board = board.board
    location[0].downto(0) do |i|
      streak = fake_board[i][current_column] == symbol ? streak + 1 : 0
      current_column += shift
      return true if streak == 4
    end
    false
  end

  def validate_diagonal_location?(location, side, board)
    return false unless location.none?(&:negative?)
    return false if location[0] < 3
    return false if side == "right" && location[1] < 3
    return false if side == "left" && (board.columns - location[1]) < 4

    true
  end

  def left_most(row, column, board)
    row_difference = (board.rows - 1) - row
    new_row = row + row_difference
    new_column = column - row_difference
    if new_column.negative?
      new_row -= new_column.abs
      new_column = 0
    end
    [new_row, new_column]
  end

  def right_most(row, column, board)
    row_difference = (board.rows - 1) - row
    new_row = row + row_difference
    new_column = column + row_difference
    if new_column > board.columns - 1
      column_difference = new_column - (board.columns - 1)
      new_row -= column_difference
      new_column -= column_difference
    end
    [new_row, new_column]
  end
end
