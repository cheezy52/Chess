require 'colorize'

class Board

  SETUP = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

  attr_accessor :grid

  def initialize(game, populated = true)
    @game = game
    @grid = build_empty_board
    build_starting_board if populated
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, arg)
    @grid[pos[0]][pos[1]] = arg
  end

  def build_empty_board
    Array.new(8) { Array.new(8) }
  end

  def build_starting_board
    8.times do |col|
      add_piece(SETUP[col], :b, [0, col])
      add_piece(Pawn, :b, [1, col])
      add_piece(Pawn, :w, [6, col])
      add_piece(SETUP[col], :w, [7, col])
    end
  end

  def dup
    new_grid = build_empty_board
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |tile, col_index|
        new_grid[row_index][col_index] = tile.dup unless tile.nil?
      end
    end
    new_board = Board.new(@game, false)
    new_board.grid = new_grid
    new_board
  end

  def add_piece(type, color, pos)
    row, col = pos
    @grid[row][col] = type.new(self, color, pos)
  end

  def to_s
    string = ""
    tile_color = :red
    string += "  a b c d e f g h\n"
    @grid.each_with_index do |row, index|
      string += "#{index+1} "
      tile_color = (tile_color == :yellow ? :red : :yellow )
      row.each do |tile|
        if tile
          string += (tile.to_s + " ").colorize(:background => tile_color)
        else
          string += "  ".colorize(:background => tile_color)
        end
        tile_color = (tile_color == :yellow ? :red : :yellow )
      end

      string += " #{index+1}\n"
    end
    string += "  a b c d e f g h\n"
    string.encode('utf-8')
  end

  def all_pieces
    pieces = []
    @grid.each do |rows|
      rows.each do |tile|
        pieces << tile if tile
      end
    end
    pieces
  end

  def on_board?(pos)
    x, y = pos
    [x, y].all? { |coord| (0..7).include?(coord) }
  end

  def in_check?(color)
    find_king(color).in_check?
  end

  def find_king(color)
    all_pieces.find { |piece| piece.class == King && piece.color == color }
  end
end