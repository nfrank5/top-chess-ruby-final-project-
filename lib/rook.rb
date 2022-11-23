require_relative './piece'
require_relative './utilities'

DIRECTIONS_ROOK = [[1, 0], [0, 1], [-1, 0], [0, -1]].freeze

class Rook < Piece
  include Utilities
  attr_accessor :first_move

  def initialize(color, position)
    super(color, position, rook_unicode(color))
    @first_move = true
  end

  def valid_moves(board)
    @moves = []
    DIRECTIONS_ROOK.map do |direction|
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

  def rook_unicode(color)
    color == 'white' ? "\u2656" : "\u265C"
  end
end