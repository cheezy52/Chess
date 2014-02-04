require_relative "board"
require_relative "player"
require_relative "piece"
require_relative "sliding_piece"
require_relative "stepping_piece"
require_relative "pieces"


class Game

  attr_reader :board

  def initialize(white_player, black_player)
    @board = Board.new(self)
    @white_player = associate_player(white_player, :w)
    @black_player = associate_player(black_player, :b)
    @current_player = @white_player
  end

  def associate_player(player, color)
    player.game = self
    player.board = @board
    player.color = color
    player
  end

  def play
    until over?
      begin
        puts @board
        start_pos, end_pos = @current_player.play_turn
        validate_start_pos(start_pos)
        @board[start_pos].move(end_pos)
      rescue => e
        p "ERROR - please retry"
        p e
        retry
      end
      # need to implement FORFEIT function
      @current_player = (@current_player == @white_player ? @black_player : @white_player)
    end
    puts "Game over!"
  end

  def valid_start_pos?(start_pos)
    if @board[start_pos].nil?
      raise ArgumentError.new("That's an empty space.")
    elsif @board[start_pos].color != @current_player.color
      raise ArgumentError.new("That's not your piece.")
    end
  end

  def over?
    #if checkmate, yes
    #if player forfeits, yes
    #if only the two kings are left on the board, yes
    false
  end
end

