class Player
  attr_accessor :color, :board, :game, :captured_pieces
  attr_reader :name

  def initialize(name)
    @name = name
    @game, @board, @color = nil, nil, nil
    @captured_pieces = []
  end

  def play_turn
    puts "It is #{@name}'s turn (#{@color == :w ? "White" : "Black"}.)"
    start_pos = get_pos("Please enter the square (e.g. a5, e2) of the piece you would like to move:")
    end_pos = get_pos("Please enter the square you would like to move to:")
    [start_pos, end_pos]
  end

  def get_pos(message)
    puts message
    pos = parse_input(gets.chomp)
    raise InvalidInputError.new("Error - Cannot parse input coordinates.") unless valid_input?(pos)
    pos
  end

  def to_s
    self.name
  end

  def valid_input?(pos)
    pos.class == Array &&
      pos.length == 2 &&
      pos.all? {|coord| coord.class == Fixnum } &&
      self.board.on_board?(pos)
  end

  def parse_input(input)
    throw(:forfeit, self) if input == "forfeit"
    throw(:save, true) if input == "save"
    raise InvalidInputError.new("Error - Input should be exactly two characters.") if input.length != 2
    col_hash = {"a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7}
    col, row = input.split("")
    row = row.to_i
    [8 - row, col_hash[col]]
  end

  def promote_pawn
    pieces = {"PAWN" => Pawn, "BISHOP" => Bishop, "KNIGHT" => Knight, "ROOK" => Rook, "QUEEN" => Queen}
    selection = ""
    begin
      puts "What piece would you like to promote your pawn to?"
      selection = gets.chomp.upcase
      raise InvalidInputError.new("Error - That is not a valid piece.") unless pieces.keys.include?(selection)
    rescue InvalidInputError => e
      puts e
      retry
    end
    pieces[selection]
  end

end