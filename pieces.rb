class Bishop < SlidingPiece
  VALUE = 3
  def move_dirs
    DIAG
  end

  def to_s
    self.color == :w ? "\u2657" : "\u265D"
  end
end

class Rook < SlidingPiece
  VALUE = 5
  def move_dirs
    HORIZ
  end

  def to_s
    self.color == :w ? "\u2656" : "\u265C"
  end
end

class Queen < SlidingPiece
  VALUE = 9
  def move_dirs
    DIAG + HORIZ
  end

  def to_s
    self.color == :w ? "\u2655" : "\u265B"
  end
end

class Knight < SteppingPiece
  VALUE = 3
  def move_dirs
    [[2, 1], [-2, 1], [2, -1], [-2, -1], [1, 2], [-1, 2], [1, -2], [-1, -2]]
  end

  def to_s
    self.color == :w ? "\u2658" : "\u265E"
  end
end

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

class Pawn < Piece
  VALUE = 1
  def build_move_list
    move_dir = self.color == :w ? -1 : 1
    valid_moves = []
    3.times do |sweep|
      test_pos = [@pos[0] + move_dir, @pos[1] + (sweep - 1)]
      if @board[test_pos].nil?
        valid_moves << test_pos if sweep == 1
      elsif !friendly_piece?(@board[test_pos])
        valid_moves << test_pos if sweep != 1
      end
    end
    if @unmoved
      test_pos = [@pos[0] + move_dir*2, @pos[1]]
      intermediate_pos = [@pos[0] + move_dir, @pos[1]]
      valid_moves << test_pos if @board[test_pos].nil? && @board[intermediate_pos].nil?
    end
    valid_moves
  end

  def to_s
    self.color == :w ? "\u2659" : "\u265F"
  end
end


