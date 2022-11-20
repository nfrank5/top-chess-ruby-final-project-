require_relative './piece'
require_relative './board'

class Bishop < Piece

  DIRECTIONS_BISHOP = [[1, 1], [-1, 1], [-1, -1], [1, -1]]

  def initialize(color, position)
    super(color, position, color == 'white' ? "\u2657" : "\u265D")
  end

  def valid_moves(board)
    @moves = []
    DIRECTIONS_BISHOP.map do |direction|
      new_position = position.slice(0..-1)
      loop do
        new_position = update_new_position(direction, new_position)
        break if board.outside_board?(new_position)

        if board.empty?(new_position)
          @moves.push(new_position)
        elsif board.enemy_piece?(position, new_position)
          @moves.push(new_position)
          break
        else
          break
        end
      end 
    end
  end
end