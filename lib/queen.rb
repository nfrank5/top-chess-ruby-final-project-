require_relative './piece'
require_relative './board'
require_relative './utilities'

DIRECTIONS_QUEEN = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]].freeze

class Queen < Piece
  include Utilities

  def initialize(color, position = queen_position(color))
    super(color, position, queen_unicode(color))
  end

  def valid_moves(board)
    @moves = []
    DIRECTIONS_QUEEN.map do |direction|
      new_position = copy_array(position)
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

  def queen_position(color)
    color == 'white' ? [7, 3] : [0, 3]
  end

  def queen_unicode(color)
    color == 'white' ? "\u2655" : "\u265B"
  end
end
