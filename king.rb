class King < SteppingPiece
  VALUE = 40
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