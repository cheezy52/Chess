require 'colorize'

class Board
  attr_accessor :grid
  def initialize(game, populated = true)
    @game = game
    @grid = build_empty_board
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

  def to_s
    string = ""
    tile_color = :yellow
    @grid.each do |row|
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

      string += "\n"
    end
    print string.encode('utf-8')
  end
end