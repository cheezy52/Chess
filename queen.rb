class Queen < SlidingPiece
  VALUE = 9
  def move_dirs
    DIAG + HORIZ
  end

  def to_s
    self.color == :w ? "\u2655" : "\u265B"
  end
end