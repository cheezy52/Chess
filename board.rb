require 'colorize'

class Board

  attr_accessor :grid

  def initialize(game, populated = true)
    @game = game
    @grid = populated ? build_starting_board : build_empty_board
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

  #todo: this
  def build_starting_board
    @grid = build_empty_board
    8.times do |col|
      @grid[1][col] = Pawn.new(self, :b, [1, col])
      @grid[6][col] = Pawn.new(self, :w, [6, col])
    end

    @grid[0][0] = Rook.new(self, :b, [0, 0])
    @grid[0][7] = Rook.new(self, :b, [0, 7])
    @grid[7][0] = Rook.new(self, :w, [7, 0])
    @grid[7][7] = Rook.new(self, :w, [7, 7])

    @grid[0][1] = Knight.new(self, :b, [0, 1])
    @grid[0][6] = Knight.new(self, :b, [0, 6])
    @grid[7][1] = Knight.new(self, :w, [7, 1])
    @grid[7][6] = Knight.new(self, :w, [7, 6])

    @grid[0][2] = Bishop.new(self, :b, [0, 2])
    @grid[0][5] = Bishop.new(self, :b, [0, 5])
    @grid[7][2] = Bishop.new(self, :w, [7, 2])
    @grid[7][5] = Bishop.new(self, :w, [7, 5])

    @grid[0][3] = King.new(self, :b, [0, 3])
    @grid[7][4] = King.new(self, :w, [7, 4])

    @grid[0][4] = Queen.new(self, :b, [0, 4])
    @grid[7][3] = Queen.new(self, :w, [7, 3])
    @grid
  end

  def create_piece_at(pos)
    # use for pawns that reach the end
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
        #string += " "
        tile_color = (tile_color == :yellow ? :red : :yellow )
      end

      string += " #{index+1}\n"
    end
    string += "  a b c d e f g h\n"
    print string.encode('utf-8')
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