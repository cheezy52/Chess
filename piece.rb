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
    # is it on the board
    # columns are letters
    # rows are numbers
    x, y = pos

    [x, y].all? { }
    # pos empty or pos contains enemy piece - OK!
    # pos contains friendly piece? - not OK
  end
end

class SlidingPiece < Piece
  HORIZ = [[1, 0], [0, 1]]
  DIAG = [[1, 1], [1, -1]]

  def valid_move?(target_pos)
    # check horiz / diag positions
    super(target_pos)
  end
end

class Bishop < SlidingPiece
end

class Rook < SlidingPiece
end

class Queen < SlidingPiece
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


