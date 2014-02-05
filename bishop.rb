class Bishop < SlidingPiece
  VALUE = 3
  def move_dirs
    DIAG
  end

  def to_s
    self.color == :w ? "\u2657" : "\u265D"
  end
end