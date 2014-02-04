class Piece
  attr_reader :board, :color, :pos
  def initialize(board, color, pos)
    @board = board
    @color = color
    @pos = pos
  end

  def move(target_pos)
    valid_move_endpoints = []
    if valid_move_endpoints.include?(target_pos)
      capture_piece(target_pos)
      self.pos = target_pos
      @board[pos] = self
    else raise RuntimeError.new("This is not a valid move position")
  end
  nil

  def capture_piece(pos)
    captured_piece = nil
    if @board[pos]
      captured_piece = @board[pos]
      @board[pos] = nil
    end
    captured_piece
  end
end