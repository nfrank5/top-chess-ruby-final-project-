require_relative './piece'
require_relative './board'

class Knight < Piece

  DIRECTIONS_KNIGHT = [[2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2], [2, -1]]

  def initialize(color, position)
    super(color, position, color == 'white' ? "\u2658" : "\u265E")
  end

  def valid_moves(board)
    @moves = []
    DIRECTIONS_KNIGHT.map do |direction|
      new_position = update_new_position(position.slice(0..-1), direction)
      next if board.outside_board?(new_position)

      if board.empty?(new_position) || board.enemy_piece?(position, new_position)
        @moves.push(new_position)
      else
        next
      end
    end
  end

end