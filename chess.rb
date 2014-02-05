require_relative "board"
require_relative "player"
require_relative "piece"
require_relative "sliding_piece"
require_relative "stepping_piece"
require_relative "pieces"
require_relative "errors"
require "colorize"


class Game

  attr_reader :board

  def initialize(white_player, black_player)
    @board = Board.new(self)
    @white_player = associate_player(white_player, :w)
    @black_player = associate_player(black_player, :b)
    @current_player = @white_player
    @winner = nil
  end

  def associate_player(player, color)
    player.game = self
    player.board = @board
    player.color = color
    player
  end

  def play
    forfeit = catch(:forfeit) do
      until over?
        begin
          puts @board
          start_pos, end_pos = @current_player.play_turn
          validate_start_pos(start_pos)
          @board[start_pos].move(end_pos)
        rescue InvalidInputError => e
          puts e
          retry
        rescue InvalidMoveError => e
          puts e
          retry
        end
        # need to implement FORFEIT function
        @current_player = (@current_player == @white_player ? @black_player : @white_player)
      end
    end
    if forfeit
      @winner = (forfeit == @white_player ? @black_player : @white_player)
    end

    puts "Game over! #{@winner} is the winner!"

    #winner-detection logic goes here
    #if we don't catch a game-over due to checkmate or draw, it was due to forfeit and current player loses
  end

  def validate_start_pos(start_pos)
    if @board[start_pos].nil?
      raise InvalidMoveError.new("Error - Starting square does not contain a piece.")
    elsif @board[start_pos].color != @current_player.color
      raise InvalidMoveError.new("Error - Cannot move your opponent's piece.")
    end
  end

  def over?
    # if checkmate, yes
    # if player forfeits, yes
    # if only the two kings are left on the board, yes
    false
  end
end

if __FILE__ == $PROGRAM_NAME
  p1 = Player.new("Alice")
  p2 = Player.new("Bob")
  g = Game.new(p1, p2)
  g.play
end
