require_relative "../lib/game"
require_relative "../lib/player"

describe Game do
  subject(:game_tester) { described_class.new }
  describe "#verify_column_input" do
    it "returns input if its between 0 and 6" do
      valid_input = game_tester.verify_column_input(5)
      expect(valid_input).to eq(5)
    end

    it "returns nil if it isn't between 0 and 6" do
      invalid_input = game_tester.verify_column_input(7)
      expect(invalid_input).to eq(nil)
    end
  end

  describe "#player_column_input" do
    context "when user number is valid" do
      before do
        valid_input = "5"
        allow(game_tester).to receive(:gets).and_return(valid_input)
      end

      it "stops loop with valid input" do
        error_message = "Input error! Please enter a number between 0 or 6."
        expect(game_tester).not_to receive(:puts).with(error_message)
        game_tester.player_column_input
      end
    end

    context "when there are previous invalid guesses" do
      before do
        invalid_input_one = "s"
        invalid_input_two = "k"
        valid_input = "4"
        allow(game_tester).to receive(:gets).and_return(invalid_input_one, invalid_input_two, valid_input)
      end

      it "shows error message twice with 2 invalid inputs" do
        error_message = "Input Error! Please provide a number between 0 and 6."
        expect(game_tester).to receive(:puts).with(error_message).twice
        game_tester.player_column_input
      end
    end
  end

  describe "#player_continue_input?" do
    context "when input is valid" do
      before do
        valid_answer = "YUP"
        allow(game_tester).to receive(:gets).and_return(valid_answer)
        allow(game_tester).to receive(:puts)
      end

      it "returns true when input is valid" do
        valid_response = game_tester.player_continue_input?
        expect(valid_response).to eq(true)
      end
    end

    context "when input is invalid" do
      before do
        invalid_answer = "NOPE"
        allow(game_tester).to receive(:gets).and_return(invalid_answer)
        allow(game_tester).to receive(:puts)
      end

      it "returns false when input isn't among the options" do
        invalid_response = game_tester.player_continue_input?
        expect(invalid_response).to eq(false)
      end
    end
  end

  describe "game_over" do
    before do
      allow(game_tester).to receive(:new_game)
      allow(game_tester).to receive(:puts)
      allow(game_tester).to receive(:player_continue_input?)
      allow(game_tester).to receive(:display_board)
    end

    let(:fake_player) { Player.new("Eddy", "X") }
    it "shows the winner if one exists" do
      winner_valid = "Winner is #{fake_player.name}"
      expect(game_tester).to receive(:puts).with(winner_valid)
      game_tester.game_over(fake_player)
    end

    it "shows draw if no winner exists" do
      draw_result = "It's a draw!"
      expect(game_tester).to receive(:puts).with(draw_result)
      game_tester.game_over
    end

    it "sets game finished" do
      game_tester.game_over
      finished_game = game_tester.instance_variable_get(:@game_finished)
      expect(finished_game).to eq(true)
    end

    context "does not call new_game when players don't want to" do
      before do
        allow(game_tester).to receive(:player_continue_input?).and_return(false)
      end

      it "does not call new_game" do
        expect(game_tester).not_to receive(:new_game)
        game_tester.game_over
      end
    end

    context "calls new_game when players want to continue" do
      before do
        allow(game_tester).to receive(:player_continue_input?).and_return(true)
      end

      it "does call new_game" do
        expect(game_tester).to receive(:new_game)
        game_tester.game_over
      end
    end
  end

  describe "#play_game" do
    context "sets up custom players properly" do
      before do
        allow(game_tester).to receive(:player_name_input).and_return("John", "Alice")
        allow(game_tester).to receive(:display_board)
        allow(game_tester).to receive(:play_round)
        game_tester.instance_variable_set(:@game_finished, true)
      end

      it "sets player 1 as John" do
        game_tester.play_game
        first_player = game_tester.instance_variable_get(:@player1)
        expect(first_player.name).to eql("John")
      end

      it "set player 2 as Alice" do
        game_tester.play_game
        second_player = game_tester.instance_variable_get(:@player2)
        expect(second_player.name).to eql("Alice")
      end
    end

    context "sets players to default if no name given" do
      before do
        allow(game_tester).to receive(:player_name_input).and_return("", "")
        allow(game_tester).to receive(:display_board)
        allow(game_tester).to receive(:play_round)
        game_tester.instance_variable_set(:@game_finished, true)
      end

      it "sets player 1 as 1" do
        game_tester.play_game
        first_player = game_tester.instance_variable_get(:@player1)
        expect(first_player.name).to eql("1")
      end

      it "set player 2 as 2" do
        game_tester.play_game
        second_player = game_tester.instance_variable_get(:@player2)
        expect(second_player.name).to eql("2")
      end
    end

    context "does not play round if game is finished" do
      before do
        allow(game_tester).to receive(:player_name_input).and_return("", "")
        allow(game_tester).to receive(:display_board)
        allow(game_tester).to receive(:play_round)
        game_tester.instance_variable_set(:@game_finished, true)
      end

      it "does not call play_round" do
        expect(game_tester).not_to receive(:play_round)
        game_tester.play_game
      end
    end

    context "calls gameover after game is finished" do
      before do
        allow(game_tester).to receive(:player_name_input).and_return("", "")
        allow(game_tester).to receive(:display_board)
        allow(game_tester).to receive(:play_round).and_return(:nil)
        allow(game_tester).to receive(:game_over)
        game_tester.instance_variable_set(:@game_finished, true)
      end

      it "calls game_over" do
        expect(game_tester).to receive(:game_over)
        game_tester.play_game
      end
    end
  end

  describe "#play_round" do
    let(:player1) { instance_double(Player, { name: "John", symbol: "X" }) }
    let(:player2) { instance_double(Player, { name: "Alice", symbol: "O" }) }

    before do
      allow(game_tester).to receive(:display_board)
      allow(game_tester).to receive(:check_win?)
      allow(game_tester).to receive(:player_column_input).and_return(5)
      game_tester.instance_variable_set(:@player1, player1)
      game_tester.instance_variable_set(:@player2, player2)
      allow(game_tester).to receive(:puts)
    end
    it "returns nil if game is finished when it's called" do
      game_tester.instance_variable_set(:@game_finished, true)
      return_value = game_tester.play_round
      expect(return_value).to be_nil
    end

    it "puts the correct statement at start of the game" do
      message = "Player #{player1.name} turn:"
      expect(game_tester).to receive(:puts).with(message)
      game_tester.play_round
    end

    context "loop breaks on first correct input" do
      it "breaks on first iteration" do
        expect(game_tester).to receive(:player_column_input).once
        game_tester.play_round
      end
    end

    context "loops breaks after several invalid inputs" do
      before do
        allow(game_tester).to receive(:player_column_input).and_return(11, 9, 3)
      end

      it "breaks on third iteration" do
        expect(game_tester).to receive(:player_column_input).exactly(3).times
        game_tester.play_round
      end
    end

    context "turns change with each round" do
      it "increases turns by 1" do
        expect { game_tester.play_round }.to change { game_tester.instance_variable_get(:@turns) }.by(1)
      end
    end

    context "returns player if he won with last move" do
      before do
        allow(game_tester).to receive(:check_win?).and_return(true)
      end
      it "returns player1" do
        winner = game_tester.play_round
        expect(winner).to eql(player1)
      end
    end

    context "returns nil when game has reached 10 turns" do
      before do
        game_tester.instance_variable_set(:@turns, 9)
      end
      it "returns nil" do
        no_winner = game_tester.play_round
        expect(no_winner).to be_nil
      end
    end

    context "returns nil by default" do
      it "returns nil" do
        no_winner = game_tester.play_round
        expect(no_winner).to be_nil
      end
    end
  end

  describe "#round_end" do
    let(:player1) { instance_double(Player, { name: "John", symbol: "X" }) }
    before do
      allow(game_tester).to receive(:check_win?)
      allow(game_tester).to receive(:puts)
    end
    context "returns player if he won with last move" do
      before do
        allow(game_tester).to receive(:check_win?).and_return(true)
      end
      it "returns player1" do
        winner = game_tester.round_end(player1, [0, 5])
        expect(winner).to eql(player1)
      end
    end

    context "returns nil when game has reached 10 turns" do
      before do
        game_tester.instance_variable_set(:@turns, 9)
      end
      it "returns nil" do
        no_winner = game_tester.round_end(player1, [0, 5])
        expect(no_winner).to be_nil
      end
    end

    context "returns nil by default" do
      it "returns nil" do
        no_winner = game_tester.round_end(player1, [0, 5])
        expect(no_winner).to be_nil
      end
    end
  end
end
