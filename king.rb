class King < SteppingPiece
  VALUE = 40
  def move_dirs
    dirs = [[1, 1], [1, 0], [1, -1], [0, 1], [0, -1], [-1, 1], [-1, 0], [-1, -1]]
    dirs
  end

  def in_check?
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

  def ok_to_castle?(target_pos)
    return false unless self.unmoved
    side = (target_pos[1] == 1 ? :l : :r)

    return false if self.in_check?

    rook_col = ( side == :l ? 0 : 7 )
    home_row = self.pos[0]
    rook_pos = [home_row, rook_col]
    return false unless @board[rook_pos].unmoved

    intermediates = ( side == :l ? [[home_row, 1], [home_row, 2], [home_row, 3]] : [[home_row, 5], [home_row, 6]])
    intermediates.each do |test_pos|
      return false unless @board[test_pos].nil?
      return false if self.move_puts_own_king_in_check?(test_pos)
    end

    true
  end
end