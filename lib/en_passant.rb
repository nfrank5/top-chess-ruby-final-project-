module EnPassant
  
  def valid_en_passant?(current, target)
    return false if attempting_en_passant?(current, target) && !current_board.piece_by_position(current).en_passant

    true
  end

  def attempting_en_passant?(current, target)
    return false unless current_board.piece_by_position(current).instance_of?(Pawn) &&
                        (current[1] - target[1]).abs == 1 &&
                        current[0] == (current_player.color == 'white' ? 3 : 4) &&
                        target[0] == (current_player.color == 'white' ? 2 : 5) &&
                        current_board.piece_by_position(target).nil?

    true
  end

  def active_en_passant(target)
    clean_previous_en_passant
    current_board.current_board[current_player.color == 'black' ? 3 : 4].each do |piece|
      en_passant_row_verification(piece, target, 'black', 'white', 3, 2)
      en_passant_row_verification(piece, target, 'white', 'black', 4, 5)
    end
  end

  def en_passant_row_verification(piece, target, current_color, other_color, row, en_passant_row)
    if current_player.color == current_color && !piece.nil? && piece.color == other_color && piece.instance_of?(Pawn)
      if current_board.piece_by_position(target).instance_of?(Pawn) && target[0] == row 
        [1, -1].each do |side_pawn|
          if current_board.piece_by_position([row, target[1] - side_pawn]).instance_of?(Pawn) &&
             current_board.piece_by_position([row, target[1] - side_pawn]).color == other_color
            current_board.piece_by_position([row, target[1] - side_pawn]).en_passant = [en_passant_row, target[1]]
          end
        end
      end
    end 
  end

  def clean_previous_en_passant
    current_board.current_board.each do |row|
      row.each do |piece|
        piece.en_passant = false if piece.instance_of?(Pawn)
      end
    end
  end

  def remove_en_passant_pawn_from_board(target)
    other_player.remove_piece([other_player.color == 'black' ? 3 : 4, target[1]])
    current_board.current_board[other_player.color == 'black' ? 3 : 4][target[1]] = nil
  end
end