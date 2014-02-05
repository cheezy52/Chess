require_relative "piece"
require_relative "sliding_piece"
require_relative "stepping_piece"
require_relative "pawn"
require_relative "rook"
require_relative "king"
require_relative "queen"
require_relative "bishop"
require_relative "knight"
require_relative "board"
require_relative "player"
require_relative "errors"
require "colorize"
require "yaml"

# TODO:
# draw conditions
# movement special cases: en passant, castling
# computer player
# source code cleanup - decomposition, line-tightening, privatization
# split up Game class into Chess (load / save) / Game (play / replay) classes
# general UI improvements

class Game

  attr_reader :board, :white_player, :black_player, :current_player, :winner, :move_history

  def initialize
    @board = Board.new(self)
    @winner = nil
    @move_history = [@board.dup]
    new_or_load
  end

  def associate_player(player, color)
    player.game = self
    player.board = @board
    player.color = color
    player
  end

  def play
    save = catch(:save) do
      forfeit = catch(:forfeit) do
        puts @board

        until over?
          begin
            next_player = (@current_player == @white_player ? @black_player : @white_player)

            start_pos, end_pos = @current_player.play_turn
            validate_start_pos(start_pos)
            @board[start_pos].move(end_pos)
            @move_history << @board.dup
          rescue InvalidInputError => e
            puts e
            retry
          rescue InvalidMoveError => e
            puts e
            retry
          end

          puts @board

          if @board.in_check?(next_player.color)
            if @board.checkmate?(next_player.color)
              @winner = @current_player
            end
          end

          @current_player = next_player
        end
      end

      if forfeit
        @winner = (forfeit == @white_player ? @black_player : @white_player)
        @move_history << "#{forfeit} forfeits the game!"
      end

      puts "Game over - #{@winner} is the winner!"

      puts "Would you like to save the replay of this game?  (y/n)"
      save = (gets.chomp.upcase == 'Y')
    end

    if save
      self.save_game
    end
  end

  def validate_start_pos(start_pos)
    if @board[start_pos].nil?
      raise InvalidMoveError.new("Error - Starting square does not contain a piece.")
    elsif @board[start_pos].color != @current_player.color
      raise InvalidMoveError.new("Error - Cannot move your opponent's piece.")
    end
  end

  def over?
    !@winner.nil?
  end

  def new_or_load
    # start new game? or load previous game?
    # if start new - self.play
    puts "Would you like to load a previous game? (y/n)"
    choice = gets.chomp.upcase
    if choice == "Y"
      load_game
    else
      get_players
      play
    end
    nil
  end

  def get_players
    puts "Player 1 (White), please enter your name: "
    @white_player = associate_player(Player.new(gets.chomp), :w)
    puts "Player 2 (Black), please enter your name: "
    @black_player = associate_player(Player.new(gets.chomp), :b)
    @current_player = @white_player
  end

  def replay
    puts "Press Enter to see next move.".yellow
    @move_history.each do |board_state|
      puts board_state
      gets.chomp
    end
    nil
  end

  def save_game
    game_name = ""
    begin
      puts "Please enter a name for this game. (Press enter for default.)"
      game_name = gets.chomp
      if !game_name.match(/[^\w]/).nil?
        raise InvalidInputError.new("Error - Please use only alphanumeric characters and underscores.")
      end
    rescue InvalidInputError => e
      puts e
      retry
    end
    game_name = "chess_game" if game_name == ""
    File.open("saves/#{game_name}_#{Time.now.strftime "%Y%m%d_%H%M%S"}.txt", "w") { |line| line.puts self.to_yaml }
  end

  def get_saved_games
    saves = {}
    filenames = Dir.entries("saves").select { |file| !File.directory?(file) }
    i = 1
    filenames.each { |filename| saves[i] = filename; i += 1 }
    saves
  end

  def load_game
    game_name = ""
    saves = get_saved_games
    number = nil
    begin
      saves.each { |num, filename| puts "#{num}. #{filename}" }

      puts nil
      puts "Please enter the number of the save file you would like to load:"
      number = gets.chomp.to_i
      raise InvalidInputError.new("Error - there is not a save file at that number.") if saves[number].nil?
    rescue InvalidInputError => e
      puts e
      retry
    end

    loaded_game = YAML::load(File.open("saves/#{saves[number]}", "r") { |f| f.read })
    loaded_game.over? ? loaded_game.replay : loaded_game.play
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new
end
