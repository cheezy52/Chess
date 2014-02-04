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
  OFFSETS = [[2, 1], [-2, 1], [2, -1], [-2, -1], [1, 2], [-1, 2], [1, -2], [-1, -2]]
  def to_s
    self.color == :w ? "\u2658" : "\u265E"
  end
end

class King < SteppingPiece
  OFFSETS = [[1, 1], [1, 0], [1, -1], [0, 1], [0, -1], [-1, 1], [-1, 0], [-1, -1]]
  def to_s
    self.color == :w ? "\u2654" : "\u265A"
  end
end

# to do
# implemented as steppingpiece FOR TESTING ONLY - full functionality todo
#class Pawn
class Pawn < SteppingPiece
  self.color == :w ? OFFSETS = [1, 0] : OFFSETS = [-1, 0]
  def to_s
    self.color == :w ? "\u2659" : "\u265F"
  end
end


