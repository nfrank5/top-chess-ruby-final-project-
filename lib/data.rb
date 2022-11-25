require 'yaml'
require_relative '../lib/input'

module Data
  include Input

  def save_games
    ans = confirm_save_game?
    if ans == 'y'
      game_name = input_name_save_game
      file = File.open("./lib/saved-games/#{game_name}.yml", 'w')
      file.puts YAML.dump({
                            one: @player_one,
                            two: @player_two,
                            board: @current_board,
                            current: @current_player,
                            other: @other_player
                          })
      file.close
      puts "The game was saved with the name: #{game_name}"
    end
    ans == 'y'
  end

  def load_game
    return unless confirm_load_game?
    file_found = false
    print_saved_games
    game_number = select_number_saved_games

    Dir.glob('./lib/saved-games/*.yml').each_with_index do |file, i|
      next unless i + 1 == game_number

      file_found = true
      game_name = file.split('/')[3].split('.')[0]
      file = YAML.load_file("./lib/saved-games/#{game_name}.yml",
                            aliases: true,
                            permitted_classes: [Symbol, Game, Player, Board,
                                                King, Queen, Pawn, Knight, Rook, Bishop])
      @player_one = file[:one]
      @player_two = file[:two]
      @current_board = file[:board]
      @current_player = file[:current]
      @other_player = file[:other]
      break
    end
    puts 'No game Found'
    file_found
  end
end