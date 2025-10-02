require_relative "../lib/board"

describe Board do
  subject(:basic_board) { described_class.new }
  describe "#initialize" do
    context "default initialize" do
      subject(:default_board) { described_class.new }

      it "has 6 rows" do
        current_rows = default_board.rows
        expect(current_rows).to eq(6)
      end

      it "has 7 columns" do
        current_columns = default_board.columns
        expect(current_columns).to eq(7)
      end
    end

    context "custom initialize" do
      subject(:custom_board) { described_class.new(8, 9) }

      it "has 8 rows" do
        current_rows = custom_board.rows
        expect(current_rows).to eq(8)
      end

      it "has 9 columns" do
        current_columns = custom_board.columns
        expect(current_columns).to eq(9)
      end
    end
  end

  describe "#make_move" do
    context "makes a move correctly" do
      it "drops X into the first row and second column" do
        basic_board.make_move(1, "X")
        expected_place = basic_board.instance_variable_get(:@my_board)[0][1]
        expect(expected_place).to eql("X")
      end

      it "drops X into second row and second column on second play" do
        basic_board.make_move(1, "X")
        basic_board.make_move(1, "O")
        expected_place = basic_board.instance_variable_get(:@my_board)[1][1]
        expect(expected_place).to eql("O")
      end
    end

    context "does not make incorrect plays" do
      it "does not drop outside of range" do
        return_value = basic_board.make_move(11, "X")
        expect(return_value).to be_nil
      end

      it "does not drop if column is full" do
        6.times { basic_board.make_move(1, "X") }
        return_value = basic_board.make_move(1, "X")
        expect(return_value).to be_nil
      end
    end
  end

  describe "#clear_board" do
    context "clears board correctly" do
      it "clear the board" do
        basic_board.make_move(1, "X")
        basic_board.clear_board
        expected_place = basic_board.instance_variable_get(:@my_board)[0][1]
        expect(expected_place).to be_empty
      end
    end
  end

  describe "#board" do
    it "returns the full board" do
      basic_board.make_move(1, "X")
      full_board = basic_board.board
      expect(full_board).to eq([
                                 ["", "X", "", "", "", "", ""],
                                 ["", "", "", "", "", "", ""],
                                 ["", "", "", "", "", "", ""],
                                 ["", "", "", "", "", "", ""],
                                 ["", "", "", "", "", "", ""],
                                 ["", "", "", "", "", "", ""]
                               ])
    end
  end

  describe "show count" do
    it "returns rows" do
      rows_count = basic_board.rows
      expect(rows_count).to eq(6)
    end
    it "returns columns" do
      columns_count = basic_board.columns
      expect(columns_count).to eq(7)
    end
  end
end
