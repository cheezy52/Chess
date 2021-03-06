require 'colorize'

class Board

  SETUP = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

  attr_accessor :grid, :graveyard

  def initialize(game, populated = true)
    @game = game
    @grid = build_empty_board
    build_starting_board if populated
    @graveyard = []
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
    new_board = Board.new(@game, false)
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |tile, col_index|
        unless tile.nil?
          new_board.add_piece(tile.class, tile.color, tile.pos.dup)
        end
      end
    end
    new_board
  end

  def promote(pawn)
    self[pawn.pos] = nil
    piece_type = @game.current_player.promote_pawn
    self.add_piece(piece_type, @game.current_player.color, pawn.pos)
  end

  def add_piece(type, color, pos)
    row, col = pos
    @grid[row][col] = type.new(self, color, pos)
  end

  def to_s
    string = ""
    tile_color = :red
    string += " #{@game.black_player} - #{dead_pieces(:w).join(" ")}\n"
    string += "  a b c d e f g h\n"
    @grid.each_with_index do |row, index|
      string += "#{8 - index} "
      tile_color = (tile_color == :yellow ? :red : :yellow )
      row.each do |tile|
        if tile
          piece_color = (tile.color == :w ? :white : :black)
          string += (tile.to_s + " ").colorize(:color => piece_color, :background => tile_color)
        else
          string += "  ".colorize(:background => tile_color)
        end
        tile_color = (tile_color == :yellow ? :red : :yellow )
      end

      string += " #{8 - index}\n"
    end
    string += "  a b c d e f g h\n"
    string += " #{@game.white_player} - #{dead_pieces(:b).join(" ")}\n"
    string += in_check_display
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

  def dead_pieces(color)
    self.graveyard.select { |piece| piece.color == color }
  end

  def in_check_display
    [:w, :b].each do |color|
      if in_check?(color)
        if checkmate?(color)
          return "#{color == :b ? "White" : "Black"} checkmates #{color == :w ? "White" : "Black"}!\n"
        else
          return "#{color == :w ? "White" : "Black"} is in check!\n"
        end
      end
    end
    ""
  end

  def no_moves?(color)
    player_pieces = self.all_pieces.select { |piece| piece.color == color }

    player_pieces.all? do |piece|
      possible_moves = piece.build_move_list
      possible_moves.all? {|pos| piece.move_puts_own_king_in_check?(pos) }
    end
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