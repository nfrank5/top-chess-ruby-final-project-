require_relative './piece'
require_relative './board'



class King < Piece
  DIRECTIONS_KING = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]

  def initialize(color)
    super(color, color == 'white' ? "\u2654" : "\u265A", color == 'white' ? [7, 4] : [0, 4])
    @first_move = true
  end

  def valid_moves(board)
    DIRECTIONS_KING.map do |direction|
      new_position = update_new_position(position.slice(0..-1), direction)
      next if board.outside_board?(new_position)

      if board.empty?(new_position)
        @moves.push(new_position)
      elsif board.can_be_taken?(position, new_position)
        @moves.push(new_position)
        next
      else
        next
      end
    end
  end
end

