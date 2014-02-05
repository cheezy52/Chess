class Rook < SlidingPiece
  VALUE = 5
  def move_dirs
    HORIZ
  end

  def to_s
    self.color == :w ? "\u2656" : "\u265C"
  end
end