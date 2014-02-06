class Piece
  attr_reader :board, :color, :value
  attr_accessor :pos, :unmoved

  def initialize(board, color, pos)
    @board = board
    @color = color
    @pos = pos
    @unmoved = true
  end

  def move(target_pos)
    if castle_move?(target_pos)
      castle(target_pos)
    elsif valid_move?(target_pos)
      capture_piece(target_pos) if @board[target_pos]
      @board[pos], @board[target_pos] = nil, self
      self.pos = target_pos

      if self.class == Pawn && self.ok_to_promote?
        @board.promote(self)
      end

    else
      raise InvalidMoveError.new("Error - This is not a valid move for #{self}.")
    end
    @unmoved = false
    nil
  end

  def castle_move?(target_pos)
    self.class == King &&
      target_pos[0] == self.pos[0] &&
      (target_pos[1] == 1 || target_pos[1] == 6) &&
      (target_pos[1] - self.pos[1]).abs > 1 &&
      self.ok_to_castle?(target_pos)
  end

  def castle(target_pos)
    row = self.pos[0]
    new_rook_pos = (target_pos[1] == 1 ? [row, 2] : [row, 5] )
    old_rook_pos = (target_pos[1] == 1 ? [row, 0] : [row, 7] )

    @board[old_rook_pos], @board[new_rook_pos] = nil, @board[old_rook_pos]
    @board[new_rook_pos].pos = new_rook_pos
    @board[new_rook_pos].unmoved = false

    @board[pos], @board[target_pos] = nil, self
    self.pos = target_pos
    good_job = "".concat("C".red + "A".light_red + "S".yellow + "T".green + "L".cyan + "E".blue)
       .concat("!".magenta.blink + "!".light_magenta.blink + "!".white.blink)
    puts good_job.blink
  end

  def capture_piece(pos)
    puts "#{self}  captures #{@board[pos]}"
    captured_piece = @board[pos].dup
    @board[pos] = nil

    board.graveyard << captured_piece
  end

  def valid_move?(target_pos)
    friendly_piece_error = InvalidMoveError.new("Error - Cannot move to position containing friendly piece.")
    off_board_error = InvalidMoveError.new("Error - Specified position is not on board.")
    in_check_error = InvalidMoveError.new("Error - Move would put self in check.")
    raise friendly_piece_error if friendly_piece?(@board[target_pos])
    raise off_board_error if !@board.on_board?(target_pos)

    move_list = self.build_move_list
    possible_move = move_list.include?(target_pos)
    raise in_check_error if possible_move && move_puts_own_king_in_check?(target_pos)
    possible_move
  end

  def move_puts_own_king_in_check?(target_pos)
    temp_board = @board.dup
    temp_board[self.pos], temp_board[target_pos] = nil, temp_board[self.pos]
    temp_board[target_pos].pos = target_pos
    temp_board.in_check?(self.color)
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
