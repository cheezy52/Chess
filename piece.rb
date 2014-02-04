class Piece
  attr_reader :board, :color, :pos

  def initialize(board, color, pos)
    @board = board
    @color = color
    @pos = pos
  end

  def move(target_pos)
    if valid_move?(target_pos)
      capture_piece(target_pos)
      self.pos = target_pos
      @board[pos] = self
    else raise RuntimeError.new("This is not a valid move position")
    end
    nil
  end

  def capture_piece(pos)
    captured_piece = nil
    if @board[pos]
      captured_piece = @board[pos]
      @board[pos] = nil
    end
    captured_piece
  end

  def valid_move?(pos)
    friendly_piece_error = RuntimeError.new("Cannot move to position containing friendly piece")
    off_board_error = ArgumentError.new("Specified position is not on board")
    # pos empty or pos contains enemy piece - OK!
    # pos contains friendly piece? - not OK
    raise friendly_piece_error if friendly_piece?(@board[pos])
    raise off_board_error if !on_board?(pos)
  end

  def on_board?(pos)
    x, y = pos
    [x, y].all? { |coord| (0..7).include?(coord) }
  end

  def friendly_piece?(piece)
    piece.color == self.color
  end
end

class SlidingPiece < Piece
  HORIZ = [[1, 0], [0, 1], [-1, 0], [0, -1]]
  DIAG = [[1, 1], [1, -1], [-1, -1], [-1, 1]]

  def valid_move?(target_pos)
    # check horiz / diag positions
    on_board?(pos)
    move_list = self.build_move_list
    super
  end

  def build_move_list
    move_list = []
    self.move_dirs.each do |vector|
      test_pos = @pos.dup

      stop = false
      until stop
        test_pos[0] += vector[0]
        test_pos[1] += vector[1]
        if on_board?(test_pos)
          if @board[test_pos].nil?
            move_list << test_pos
          else
            move_list << test_pos unless friendly_piece?(@board[test_pos])
            stop = true
          end
        else
          stop = true
        end
      end
    end
    move_list
  end
end

class Bishop < SlidingPiece
  def move_dirs
    DIAG
  end
end

class Rook < SlidingPiece
  def move_dirs
    HORIZ
  end
end

class Queen < SlidingPiece
  def move_dirs
    DIAG + HORIZ
  end
end

class SteppingPiece < Piece
  OFFSETS = [[]]
  def valid_move?(target_pos)
    # check if valid move coord
    super(target_pos)
  end

end

class Knight < SteppingPiece
end

class King < SteppingPiece
end

# to do
class Pawn
end


