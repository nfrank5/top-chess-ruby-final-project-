require_relative './piece'
require_relative './board'
require_relative './utilities'

DIRECTIONS_KNIGHT = [[2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2], [2, -1]].freeze

class Knight < Piece
  include Utilities

  def initialize(color, position)
    super(color, position, knight_unicode(color) )
  end

  def valid_moves(board)
    @moves = []
    DIRECTIONS_KNIGHT.map do |direction|
      new_position = update_new_position(copy_array(position), direction)
      next if board.outside_board?(new_position)

      if board.empty?(new_position) || board.enemy_piece?(position, new_position)
        @moves.push(new_position)
      else
        next
      end
    end
  end

  def knight_unicode(color)
    color == 'white' ? "\u2658" : "\u265E"
  end
end