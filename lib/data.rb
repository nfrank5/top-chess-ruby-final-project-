require 'yaml'
require_relative '../lib/input'

module Data
  include Input
  
  def save_games
    puts 'Do you want to save the game?(Y/N)'
    ans = player_input(/^[ynYN]$/, 'Only one letter Y or N')
    if(ans.downcase == 'y')
      puts 'Enter a name to save the game(3 to 10 letters): '
      game_name = player_input(/^[a-zA-Z0-9\-_]{3,10}$/, "Only letters, numbers, dash(-) and underscore(_)")
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
    puts 'Do you want to load a saved Game?(Y/N)'
    ans = player_input(/^[ynYN]$/, 'Input just one letter "Y" for Yes or "N" for No' )
    return unless ans == 'y'
    puts 'Saved Games:'
    Dir.glob('./lib/saved-games/*.yml').each do | file | 
      puts " - #{file.split('/')[3].split('.')[0]}"
    end
    puts 'Write the name of the game you want to load'
    game_name = player_input(/^[a-zA-Z0-9]{3,10}$/, 'Write the exact name of the game, case sensitive')

    Dir.glob('./lib/saved-games/*.yml').each do |file|
      if(file == "./lib/saved-games/#{game_name}.yml")
        file = YAML.load_file("./lib/saved-games/#{game_name}.yml", aliases: true, permitted_classes: [Symbol, Game, Player, Board, King, Queen, Pawn, Knight, Rook, Bishop])
        @player_one = file[:one]
        @player_two = file[:two]
        @current_board = file[:board]
        @current_player = file[:current]
        @other_player = file[:other]
        break
      end
    end
    ans == 'y'
  end
end