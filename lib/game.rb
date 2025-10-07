require_relative "board"
require_relative "player"
require_relative "win_check"
# Main Game Class
class Game
  include WinCheck

  def initialize
    @current_board = Board.new
    @turns = 1
    @game_finished = false
  end

  def verify_column_input(input)
    input if input.between?(0, @current_board.columns - 1)
  end

  def play_game
    first_player = player_name_input("First Player Name:")
    second_player = player_name_input("Second Player Name:")
    @player1 = Player.new(first_player.empty? ? "1" : first_player, "X")
    @player2 = Player.new(second_player.empty? ? "2" : second_player, "O")
    final_result = play_round until @game_finished == true
    game_over(final_result)
  end

  def play_round
    return nil if @game_finished

    display_board
    current_player = @turns.odd? ? @player1 : @player2
    puts "Player #{current_player.name} turn:"
    last_move = nil
    loop do
      user_move = player_column_input
      last_move = @current_board.make_move(user_move, current_player.symbol)
      break if last_move
    end
    @turns += 1
    round_end(current_player, last_move)
  end

  def round_end(current_player, last_move)
    if check_win?(last_move, current_player.symbol, @current_board)
      @game_finished = true
      current_player
    elsif @turns == @current_board.rows * @current_board.columns
      @game_finished = true
      nil
    end
  end

  def player_column_input
    loop do
      user_input = gets.chomp
      verified_number = verify_column_input(user_input.to_i) if user_input.match?(/^\d$/)
      return verified_number if verified_number

      puts "Input Error! Please provide a number between 0 and #{@current_board.columns - 1}."
    end
  end

  def new_game
    @current_board.clear_board
    @turns = 1
    @game_finished = false
    play_game
  end

  def game_over(winner = nil)
    if winner
      puts "Winner is #{winner.name}"
    else
      puts "It's a draw!"
    end
    @game_finished = true
    display_board
    new_game if player_continue_input?
  end

  def player_continue_input?
    puts "Do you wish to play again?"
    player_answer = gets.chomp.strip.downcase
    return true if %w[y yes yup].include?(player_answer)

    false
  end

  private

  def display_board
    puts @current_board.board.reverse.map(&:inspect)
  end

  def player_name_input(message)
    puts message
    gets.chomp.strip
  end
end
