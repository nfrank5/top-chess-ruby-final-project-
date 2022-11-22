module Castling

  TOWER_MOVE_FOR_CASTLING = { [0, 2] => [[0, 0], [0, 3]],
    [0, 6] => [[0, 7], [0, 5]],
    [7, 2] => [[7, 0], [7, 3]],
    [7, 6] => [[7, 7], [7, 5]] }.freeze
  PASSING_KING_SQUARES_CASTLING = { [0, 2] => [0, 3],
          [0, 6] => [0, 5],
          [7, 2] => [7, 3],
          [7, 6] => [7, 5] }.freeze

  def valid_castling?(current, target)
    if attempting_castling?(current, target) && (current_board.check?(other_player, current_player) ||
                           other_player.all_pieces_moves.include?(PASSING_KING_SQUARES_CASTLING[target]))
      puts 'Invalid castling'
      return false
    end
    true
  end

  def attempting_castling?(current, target)
    current_board.piece_by_position(current).class
    return true if current_board.piece_by_position(current).instance_of?(King) && (current[1] - target[1]).abs > 1

    false
  end

end