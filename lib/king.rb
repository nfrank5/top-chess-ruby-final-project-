require_relative './piece'
require_relative './board'
require_relative './utilities'

DIRECTIONS_KING = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]].freeze

class King < Piece
  include Utilities
  attr_accessor :first_move

  def initialize(color)
    super(color, king_position(color), king_unicode(color))
    @first_move = true
  end

  def valid_moves(board)
    @moves = []
    DIRECTIONS_KING.map do |direction|
      new_position = update_new_position(copy_array(position), direction)
      next if board.outside_board?(new_position)

      if board.empty?(new_position)
        @moves.push(new_position)
      elsif board.enemy_piece?(position, new_position)
        @moves.push(new_position)
        next
      else
        next
      end
    end
    castling_moves(board)
  end

  def king_unicode(color)
    color == 'white' ? "\u2654" : "\u265A"
  end

  def king_position(color)
    color == 'white' ? [7, 4] : [0, 4]
  end

  def castling_moves(board)
    return unless first_move

    [[0, 0], [0, 7], [7, 0], [7, 7]].each do |corner|
      piece = board.piece_by_position(corner)
      rook_to_king_clear?(corner, board) if rook_not_yet_moved(piece)
    end
  end

  def rook_not_yet_moved(piece)
    !piece.nil? && piece.instance_of?(Rook) && piece.color == color && piece.first_move
  end

  def rook_to_king_clear?(corner, board)
    case corner
    when [0, 0]
      @moves.push([0, 2]) if board.all_empty?([[0, 3], [0, 2], [0, 1]])
    when [0, 7]
      @moves.push([0, 6]) if board.all_empty?([[0, 5], [0, 6]])
    when [7, 0]
      @moves.push([7, 2]) if board.all_empty?([[7, 3], [7, 2], [7, 1]])
    when [7, 7]
      @moves.push([7, 6]) if board.all_empty?([[7, 5], [7, 6]])
    end
  end
end

