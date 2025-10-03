require_relative "../lib/win_check"
require_relative "../lib/board"

describe WinCheck do
  let(:win_checker) { Class.new { extend WinCheck } }
  let(:test_board) { Board.new }
  let(:player_symbol) { "X" }
  describe "#vertical_win?" do
    it "returns true if the move is a vertical win" do
      4.times { test_board.make_move(0, player_symbol) }
      possible_win = win_checker.vertical_win?(0, player_symbol, test_board)
      expect(possible_win).to eq(true)
    end

    it "returns false if the move isn't a vertical win" do
      test_board.make_move(0, player_symbol)
      possible_win = win_checker.vertical_win?(0, player_symbol, test_board)
      expect(possible_win).to eq(false)
    end
  end

  describe "#horizontal_win?" do
    it "returns true if the move is a horizontal win" do
      4.times { |i| test_board.make_move(i, player_symbol) }
      possible_win = win_checker.horizontal_win?(0, player_symbol, test_board)
      expect(possible_win).to eq(true)
    end

    it "returns false if the move isn't a horizontal win" do
      test_board.make_move(0, player_symbol)
      possible_win = win_checker.horizontal_win?(0, player_symbol, test_board)
      expect(possible_win).to eq(false)
    end
  end

  describe "#left_most" do
    it "returns a far left most location" do
      possible_location = win_checker.left_most(2, 2, test_board)
      expect(possible_location).to eql([4, 0])
    end

    it "returns the closest location" do
      possible_location = win_checker.left_most(4, 5, test_board)
      expect(possible_location).to eql([5, 4])
    end

    it "returns same location when at the bottom left" do
      possible_location = win_checker.left_most(0, 0, test_board)
      expect(possible_location).to eql([0, 0])
    end

    it "returns same location when at top right" do
      possible_location = win_checker.left_most(5, 6, test_board)
      expect(possible_location).to eql([5, 6])
    end
  end

  describe "#right_most" do
    it "returns a far right most location" do
      possible_location = win_checker.right_most(2, 2, test_board)
      expect(possible_location).to eql([5, 5])
    end

    it "returns the closest location" do
      possible_location = win_checker.right_most(4, 5, test_board)
      expect(possible_location).to eql([5, 6])
    end

    it "returns same location when at the bottom right" do
      possible_location = win_checker.right_most(0, 6, test_board)
      expect(possible_location).to eql([0, 6])
    end

    it "returns same location when at top left" do
      possible_location = win_checker.right_most(5, 0, test_board)
      expect(possible_location).to eql([5, 0])
    end
  end

  describe "#validate_diagonal_location" do
    it "returns false if a number is negative" do
      valid_location = win_checker.validate_diagonal_location?([-1, 2], "right", test_board)
      expect(valid_location).to eq(false)
    end

    it "returns false when row isn't 3 at least" do
      valid_location = win_checker.validate_diagonal_location?([2, 2], "right", test_board)
      expect(valid_location).to eq(false)
    end

    it "returns false if it's right and column isn't 3 at least" do
      valid_location = win_checker.validate_diagonal_location?([5, 2], "right", test_board)
      expect(valid_location).to eq(false)
    end

    it "returns false if it's left and column is too close to column size" do
      valid_location = win_checker.validate_diagonal_location?([5, 4], "left", test_board)
      expect(valid_location).to eq(false)
    end

    it "returns true when it's a valid diagonal position for a win from left" do
      valid_location = win_checker.validate_diagonal_location?([3, 3], "left", test_board)
      expect(valid_location).to eq(true)
    end

    it "returns true when it's a valid diagonal position for a win from right" do
      valid_location = win_checker.validate_diagonal_location?([3, 3], "right", test_board)
      expect(valid_location).to eq(true)
    end
  end

  describe "#check_diagonal?" do
    context "works as intended" do
      before do
        4.times do |_j|
          4.times { |i| test_board.make_move(i, player_symbol) }
        end
      end
      it "returns true when it's a valid diagonal from left most" do
        valid_win = win_checker.check_diagonal?([3, 0], player_symbol, "left", test_board)
        expect(valid_win).to eq(true)
      end

      it "returns true when it's a valid diagonal from right most" do
        valid_win = win_checker.check_diagonal?([3, 3], player_symbol, "right", test_board)
        expect(valid_win).to eq(true)
      end

      it "returns false when it's not a valid diagonal from left most " do
        valid_win = win_checker.check_diagonal?([3, 1], player_symbol, "left", test_board)
        expect(valid_win).to eq(false)
      end

      it "returns false when it's not valid diagonal from right most" do
        valid_win = win_checker.check_diagonal?([3, 2], player_symbol, "right", test_board)
        expect(valid_win).to eq(false)
      end
    end
  end

  describe "#diagonal_win?" do
    context "works as intended" do
      before do
        4.times do |_j|
          4.times { |i| test_board.make_move(i, player_symbol) }
        end
      end

      it "returns true when it's a valid diagonal from left most" do
        valid_win = win_checker.diagonal_win?([2, 1], player_symbol, test_board)
        expect(valid_win).to eq(true)
      end

      it "returns true when it's a valid diagonal from right most" do
        valid_win = win_checker.diagonal_win?([2, 2], player_symbol, test_board)
        expect(valid_win).to eq(true)
      end
    end
  end
end
