class Bishop < SlidingPiece
  def move_dirs
    DIAG
  end

  def to_s
    self.color == :w ? "\u2657" : "\u265D"
  end
end

class Rook < SlidingPiece
  def move_dirs
    HORIZ
  end

  def to_s
    self.color == :w ? "\u2656" : "\u265C"
  end
end

class Queen < SlidingPiece
  def move_dirs
    DIAG + HORIZ
  end

  def to_s
    self.color == :w ? "\u2655" : "\u265B"
  end
end

class Knight < SteppingPiece

  def move_dirs
    [[2, 1], [-2, 1], [2, -1], [-2, -1], [1, 2], [-1, 2], [1, -2], [-1, -2]]
  end

  def to_s
    self.color == :w ? "\u2658" : "\u265E"
  end
end

class King < SteppingPiece

  def move_dirs
    [[1, 1], [1, 0], [1, -1], [0, 1], [0, -1], [-1, 1], [-1, 0], [-1, -1]]
  end

  def in_check?
    # look through all
    other_player_color = ( self.color == :w ? :b : :w )
    enemy_pieces = @board.all_pieces.select do |piece|
      piece.color == other_player_color
    end
    threatened_squares = []
    enemy_pieces.each do |piece|
      threatened_squares += piece.build_move_list
    end
    threatened_squares.include?(self.pos)
  end

  def to_s
    self.color == :w ? "\u2654" : "\u265A"
  end
end

# to do
# implemented as steppingpiece FOR TESTING ONLY - full functionality todo
#class Pawn
class Pawn < SteppingPiece

  def move_dirs
    [[1, 0], [-1, 0]]
  end

  def to_s
    self.color == :w ? "\u2659" : "\u265F"
  end
end


