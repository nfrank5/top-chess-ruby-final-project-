require_relative './piece'
require_relative './utilities'

DIRECTIONS_PAWN = { 'white' => [[-1, -1], [-1, 1], [-1, 0], [-2, 0]], 'black' => [[1, -1], [1, 1], [1, 0], [2, 0]]}.freeze

class Pawn < Piece
  include Utilities
  attr_accessor :first_move, :en_passant

  def initialize(color, position)
    super(color, position, pawn_unicode(color))
    @first_move = true
    @en_passant = false
  end

  def valid_moves(board)
    @moves = []

    DIRECTIONS_PAWN[color].map do |direction|
      new_position = update_new_position(copy_array(position), direction)
      next if board.outside_board?(new_position)

      if one_square_forward?(board, new_position, direction)
        @moves.push(new_position)
      elsif double_step?(direction, board, new_position)
        @moves.push(new_position)
      elsif pawn_taking(direction, board, position, new_position)
        @moves.push(new_position)
      end
    end
    @moves.push(@en_passant) if @en_passant
  end

  def pawn_unicode(color)
    color == 'white' ? "\u2659" : "\u265F"
  end

  def one_square_forward?(board, new_position, direction)
    board.empty?(new_position) && [[-1, 0], [1, 0]].include?(direction)
  end

  def double_step?(direction, board, new_position)
    first_move && [[-2, 0], [2, 0]].include?(direction) && board.empty?(new_position) &&
      board.empty?(color == 'white' ? [5, new_position[1]] : [2, new_position[1]])
  end

  def pawn_taking(direction, board, position, new_position)
    [[-1, -1], [-1, 1], [1, -1], [1, 1]].include?(direction) && board.enemy_piece?(position, new_position)
  end
end
