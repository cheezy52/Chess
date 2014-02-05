require_relative "piece"
require_relative "sliding_piece"
require_relative "stepping_piece"
require_relative "pieces"
require_relative "board"
require_relative "player"
require_relative "errors"
require "colorize"

#TODO: Victory/draw conditions
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
          next_player = (@current_player == @white_player ? @black_player : @white_player)
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

        if @board.in_check?(next_player.color)
          if checkmate?(next_player)
            @winner = @current_player
            puts "Checkmate! Good work, #{@current_player}."
          else
            puts "#{next_player} - You are in check!"
          end
        end
        @current_player = next_player
      end
    end

    if forfeit
      @winner = (forfeit == @white_player ? @black_player : @white_player)
    end

    puts @board
    puts "Game over - #{@winner} is the winner!"
  end

  def validate_start_pos(start_pos)
    if @board[start_pos].nil?
      raise InvalidMoveError.new("Error - Starting square does not contain a piece.")
    elsif @board[start_pos].color != @current_player.color
      raise InvalidMoveError.new("Error - Cannot move your opponent's piece.")
    end
  end

  def checkmate?(player)
    color = player.color
    player_pieces = @board.all_pieces.select { |piece| piece.color == color }

    player_pieces.all? do |piece|
      possible_moves = piece.build_move_list
      possible_moves.all? {|pos| piece.move_puts_own_king_in_check?(pos) }
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
