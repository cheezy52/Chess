class Piece
  attr_reader :board, :color
  attr_accessor :pos

  def initialize(board, color, pos)
    @board = board
    @color = color
    @pos = pos
    @board[pos] = self
  end

  def move(target_pos)
    if valid_move?(target_pos)
      capture_piece(target_pos) if @board[target_pos]
      @board[pos], @board[target_pos] = nil, self
      self.pos = target_pos
    else raise RuntimeError.new("This is not a valid move position")
    end
    nil
  end

  def capture_piece(pos)
    puts "#{self} captures #{@board[pos]}"
    captured_piece = @board[pos]
    @board[pos] = nil
    captured_piece
  end

  def valid_move?(pos)
    friendly_piece_error = RuntimeError.new("Cannot move to position containing friendly piece")
    off_board_error = ArgumentError.new("Specified position is not on board")
    # pos empty or pos contains enemy piece - OK!
    # pos contains friendly piece? - not OK
    raise friendly_piece_error if friendly_piece?(@board[pos])
    raise off_board_error if !@board.on_board?(pos)
  end

  def on_board?(pos)
    x, y = pos
    [x, y].all? { |coord| (0..7).include?(coord) }
  end

  def friendly_piece?(piece)
    piece.color == self.color
  end
end
