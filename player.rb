class Player
  attr_accessor :color, :board, :game
  attr_reader :name

  def initialize(name)
    @name = name
    @game, @board, @color = nil, nil, nil
  end

  def play_turn
    start_pos = get_pos("Please enter the square (e.g. a5, e2) of the piece you would like to move:")
    end_pos = get_pos("Please enter the square you would like to move to: ")

    [start_pos, end_pos]
  end

  def get_pos(message)
    begin
      puts message
      pos = parse_input(gets.chomp)
      raise ArgumentError.new("Input invalid.  Please re-enter.") unless valid_input?(pos)
    rescue ArgumentError => e
      puts e
      retry
    end
    pos
  end

  def valid_input?(pos)
    # maybe make this prettier
    pos.class == Array &&
      pos.length == 2 &&
      pos.all? {|coord| coord.class == Fixnum } &&
      self.board.on_board?(pos)
  end

  def parse_input(input)
    #get passed in a raw string from gets.chomp
    #should be of format "a5", "e2", etc.
    #decode to two-element array of indices on board
    raise ArgumentError.new("Please enter a valid square.") if input.length != 2
    col_hash = {"a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7}
    col, row = input.split("")
    row = row.to_i
    [row - 1, col_hash[col]]
  end
end