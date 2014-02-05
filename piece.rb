class Piece
  attr_reader :board, :color
  attr_accessor :pos

  def initialize(board, color, pos)
    @board = board
    @color = color
    @pos = pos
  end

  def move(target_pos)
    if valid_move?(target_pos)
      capture_piece(target_pos) if @board[target_pos]
      @board[pos], @board[target_pos] = nil, self
      self.pos = target_pos
    else raise InvalidMoveError.new("Error - This is not a valid move for #{self}.")
    end
    nil
  end

  def capture_piece(pos)
    puts "#{self} captures #{@board[pos]}"
    captured_piece = @board[pos]
    @board[pos] = nil
    captured_piece
  end

  def valid_move?(target_pos)
    friendly_piece_error = InvalidMoveError.new("Error - Cannot move to position containing friendly piece.")
    off_board_error = InvalidMoveError.new("Error - Specified position is not on board.")
    raise friendly_piece_error if friendly_piece?(@board[target_pos])
    raise off_board_error if !@board.on_board?(target_pos)

    move_list = self.build_move_list
    move_list.include?(target_pos)
  end

  def on_board?(pos)
    x, y = pos
    [x, y].all? { |coord| (0..7).include?(coord) }
  end

  def friendly_piece?(piece)
    return false if piece.nil?
    piece.color == self.color
  end
end
