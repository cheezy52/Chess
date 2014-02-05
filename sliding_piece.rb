class SlidingPiece < Piece
  HORIZ = [[1, 0], [0, 1], [-1, 0], [0, -1]]
  DIAG = [[1, 1], [1, -1], [-1, -1], [-1, 1]]


  def build_move_list
    move_list = []
    self.move_dirs.each do |vector|
      test_pos = @pos.dup

      stop = false
      until stop
        test_pos[0] += vector[0]
        test_pos[1] += vector[1]
        if @board.on_board?(test_pos)
          if @board[test_pos].nil?
            move_list << test_pos.dup
          else
            move_list << test_pos.dup unless friendly_piece?(@board[test_pos])
            stop = true
          end
        else
          stop = true
        end
      end
    end
    move_list
  end
end

