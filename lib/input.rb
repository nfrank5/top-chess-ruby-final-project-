module Input

  def player_input(regex, error_msg)
    loop do
      user_input = gets.chomp
      verified_input = user_input if user_input.match?(regex)
      return verified_input if verified_input

      puts error_msg
    end
  end

  def input_move
    puts "It is #{current_player.name} turn."
    current_position_and_target = player_input(/^([0-7]{2} {1,3}[0-7]{2})$|^save$/i, "Please insert your move using two digits (from) followed by a space and then two more digits (to)\nWrite the row first and then column")
    return current_position_and_target.downcase if current_position_and_target.downcase == 'save'

    format_input_move(current_position_and_target)
  end

  def format_input_move(current_position_and_target)
    current_position_and_target.split(' ').inject([]) do |formatted, str| 
      str = str.split('') 
      formatted.push([str[0].to_i, str[1].to_i])
    end
  end

  def input_pawn_promotion(current_player)
    puts 'Select a Rook, Bishop, Queen or Knight'
    player_input(/^[a-z]{4,6}$/i, "#{current_player.name} write the name of a piece to promote your pawn").downcase
  end

  def confirm_save_game?
    clear_screen
    puts 'Do you want to save the game?(Y/N)'
    player_input(/^[ynYN]$/, 'Write only one letter Y or N').downcase
  end

  def input_name_save_game
    puts 'Enter a name to save the game(3 to 10 letters): '
    player_input(/^[a-zA-Z0-9\-_]{3,10}$/, 'Only letters, numbers, dash(-) and underscore(_)')
  end

  def confirm_load_game?
    puts 'Do you want to load a saved Game?(Y/N)'
    ans = player_input(/^[ynYN]$/, 'Input just one letter "Y" for Yes or "N" for No')
    ans == 'y'
  end

  def print_saved_games
    puts 'Saved Games:'
    Dir.glob('./lib/saved-games/*.yml').each_with_index do |file, i|
      puts "#{i + 1} - #{file.split('/')[3].split('.')[0]}"
    end
  end

  def select_number_saved_games
    puts 'Write the number of the game you want to load'
    player_input(/^[0-9]$/, 'Please write the exact number of the game').to_i
  end
end