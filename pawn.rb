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

  def ok_to_promote?
    self.pos[0] == 0 || self.pos[0] == 7
  end

  def to_s
    self.color == :w ? "\u2659" : "\u265F"
  end
end