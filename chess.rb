require_relative "board"
require_relative "player"
require_relative "piece"
require_relative "sliding_piece"
require_relative "stepping_piece"
require_relative "pieces"


class Game
  def initialize(white_player, black_player)
    @white_player = white_player
    @black_player = black_player
    @current_player = @white_player
    @board = Board.new(self)
  end

  def play
    until over?
      begin
        puts @board
        start_pos, end_pos = @current_player.play_turn
        @board[start_pos].move(end_pos)
      rescue
        p "ERROR - please retry"
        retry
      end
      # need to implement FORFEIT function
      @current_player = (@current_player == @white_player ? @black_player : @white_player)
    end
    puts "Game over!"
  end

  def over?
    #if checkmate, yes
    #if player forfeits, yes
    #if only the two kings are left on the board, yes
    false
  end
end

