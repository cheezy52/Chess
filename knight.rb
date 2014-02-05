class Knight < SteppingPiece
  VALUE = 3
  def move_dirs
    [[2, 1], [-2, 1], [2, -1], [-2, -1], [1, 2], [-1, 2], [1, -2], [-1, -2]]
  end

  def to_s
    self.color == :w ? "\u2658" : "\u265E"
  end
end