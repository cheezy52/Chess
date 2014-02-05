require_relative "piece"
require_relative "sliding_piece"
require_relative "stepping_piece"
require_relative "pieces"
require_relative "board"
require_relative "player"
require_relative "errors"
require "colorize"

# TODO:
# draw conditions
# movement special cases: en passant, castling, pawn promotion
# computer player
# save / load; replays?
# source code cleanup - finish splitting classes, decomposition, line-tightening, privatization
# general UI improvements

class Game

  attr_reader :board, :white_player, :black_player, :current_player

  def initialize(white_player, black_player)
    @board = Board.new(self)
    @white_player = associate_player(white_player, :w)
    @black_player = associate_player(black_player, :b)
    @current_player = @white_player
    @winner = nil
    @move_history = [@board.dup]
  end

  def associate_player(player, color)
    player.game = self
    player.board = @board
    player.color = color
    player
  end

  def play
    forfeit = catch(:forfeit) do
      puts @board

      until over?
        begin
          next_player = (@current_player == @white_player ? @black_player : @white_player)

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

        puts @board

        if @board.in_check?(next_player.color)
          if @board.checkmate?(next_player.color)
            @winner = @current_player
          end
        end

        @current_player = next_player
      end
    end

    if forfeit
      @winner = (forfeit == @white_player ? @black_player : @white_player)
    end

    puts "Game over - #{@winner} is the winner!"
  end

  def validate_start_pos(start_pos)
    if @board[start_pos].nil?
      raise InvalidMoveError.new("Error - Starting square does not contain a piece.")
    elsif @board[start_pos].color != @current_player.color
      raise InvalidMoveError.new("Error - Cannot move your opponent's piece.")
    end
  end

  def over?
    !@winner.nil?
  end

end

if __FILE__ == $PROGRAM_NAME
  p1 = Player.new("Alice")
  p2 = Player.new("Bob")
  g = Game.new(p1, p2)
  g.play
end
