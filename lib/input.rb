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
    puts "#{current_player.name} choose a piece and move it selecting its origin and destiny" 
    puts 'For example 64 44, write the row first and then column'
    current_position_and_target = player_input(/^([0-7]{2} {1,3}[0-7]{2})$|^save$/i, 'Please insert your move using two digits followed by a space and then two more digits')
    return current_position_and_target.downcase if current_position_and_target.downcase == 'save'

    format_input_move(current_position_and_target)
  end

  def format_input_move(current_position_and_target)
    current_position_and_target.split(' ').inject([]) do |formatted, str| 
      str = str.split('') 
      formatted.push([str[0].to_i, str[1].to_i])
    end
  end

  def select_pawn_promotion(current_player, piece)
    puts 'Select a Rook, Bishop, Queen or Knight'
    selected = false
    until selected do
      promote_to = player_input(/^[a-z]{4,6}$/i, "#{current_player.name} write the name of a piece to promote your pawn")
      case promote_to.downcase
      when 'rook'
        current_player.pieces.push(Rook.new(current_player.color, piece.position))
        selected = true
      when 'knight'
        current_player.pieces.push(Knight.new(current_player.color, piece.position))
        selected = true
      when 'queen'
        current_player.pieces.push(Queen.new(current_player.color, piece.position))
        selected = true
      when 'bishop'
        current_player.pieces.push(Bishop.new(current_player.color, piece.position))
        selected = true
      else
        selected == false
      end
    end
  end
end