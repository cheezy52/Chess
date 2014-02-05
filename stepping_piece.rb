class SteppingPiece < Piece

  def build_move_list
    move_list = []
    self.move_dirs.each do |offset|
      test_pos = @pos.dup
      test_pos[0] += offset[0]
      test_pos[1] += offset[1]
      if @board.on_board?(test_pos)
        if @board[test_pos].nil?
          move_list << test_pos
        else
          move_list << test_pos unless friendly_piece?(@board[test_pos])
        end
      end
    end
    move_list
  end

end

