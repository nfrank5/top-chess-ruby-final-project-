require_relative './piece'
require_relative './board'
require_relative './utilities'

DIRECTIONS_BISHOP = [[1, 1], [-1, 1], [-1, -1], [1, -1]].freeze

class Bishop < Piece
  include Utilities

  def initialize(color, position)
    super(color, position, bishop_unicode(color))
  end

  def valid_moves(board)
    @moves = []
    DIRECTIONS_BISHOP.map do |direction|
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

  def bishop_unicode(color)
    color == 'white' ? "\u2657" : "\u265D"
  end
end